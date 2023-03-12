module "role" {
  source                 = "./role"
  aws_project_id         = var.aws_project_id
  cloudwatch_group_name  = var.cloudwatch_group_name
  owner                  = var.owner
  codecommit_arn         = aws_codecommit_repository.tf_codecommit.arn
  codebuild_project_name = var.codebuild_project_name
  codepipeline_arn       = aws_codepipeline.tf_codepipeline.arn
}

resource "aws_codecommit_repository" "tf_codecommit" {
  repository_name = var.codecommit_repo_name
  description     = ""
  tags            = { "owner" : var.owner }
}

resource "aws_codebuild_project" "tf_codebuild" {
  name          = var.codebuild_project_name
  description   = ""
  build_timeout = "5"
  service_role  = module.role.codebuild_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  source_version = "refs/heads/${var.codecommit_branch}"

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      type  = "PLAINTEXT"
      value = var.aws_region
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = var.aws_project_id
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = var.cloudwatch_group_name
      status      = "ENABLED"
      stream_name = var.cloudwatch_stream_name
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }

  }

  source {
    git_clone_depth     = 1
    insecure_ssl        = false
    location            = aws_codecommit_repository.tf_codecommit.clone_url_http
    report_build_status = false
    type                = "CODECOMMIT"

    git_submodules_config {
      fetch_submodules = false
    }
  }

  tags = { "owner" : var.owner }
}

resource "aws_codepipeline" "tf_codepipeline" {
  name     = var.codepipeline_project_name
  role_arn = module.role.codepipeline_arn

  artifact_store {
    location = "ivan-codepipeline"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "BranchName"           = var.codecommit_branch
        "OutputArtifactFormat" = "CODE_ZIP"
        "PollForSourceChanges" = "false"
        "RepositoryName"       = var.codecommit_repo_name
      }
      input_artifacts = []
      name            = "Source"
      namespace       = "SourceVariables"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeCommit"
      region    = "ap-northeast-1"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = var.codebuild_project_name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name      = "Build"
      namespace = "BuildVariables"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      region    = "ap-northeast-1"
      run_order = 1
      version   = "1"
    }
  }

  tags = { "owner" : var.owner }
}
