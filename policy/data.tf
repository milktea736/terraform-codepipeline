variable "aws_project_id" {}
variable "cloudwatch_group_name" {}
variable "codecommit_arn" {}
variable "codebuild_project_name" {}
variable "codepipeline_arn" {}

data "aws_iam_policy_document" "allow_push_ecr" {
  statement {
    sid = "VisualEditor0"
    actions = [
      "ecr:PutLifecyclePolicy",
      "ecr:PutImageTagMutability",
      "ecr:StartImageScan",
      "ecr:CreateRepository",
      "ecr:PutImageScanningConfiguration",
      "ecr:UploadLayerPart",
      "ecr:BatchDeleteImage",
      "ecr:PutRegistryScanningConfiguration",
      "ecr:CreatePullThroughCacheRule",
      "ecr:DeletePullThroughCacheRule",
      "ecr:DeleteLifecyclePolicy",
      "ecr:DeleteRepository",
      "ecr:PutImage",
      "ecr:BatchImportUpstreamImage",
      "ecr:CompleteLayerUpload",
      "ecr:StartLifecyclePolicyPreview",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:ReplicateImage",
      "ecr:PutReplicationConfiguration",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "allow_login_ecr" {
  statement {
    sid = "VisualEditor0"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "codebuild_base_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:ap-northeast-1:${var.aws_project_id}:log-group:/aws/codebuild/${var.codebuild_project_name}",
      "arn:aws:logs:ap-northeast-1:${var.aws_project_id}:log-group:/aws/codebuild/${var.codebuild_project_name}:*"
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:::ivan-codepipeline*"
    ]
  }

  statement {
    actions = [
      "codecommit:GitPull"
    ]
    resources = [
      var.codecommit_arn
    ]
  }

  statement {
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      "arn:aws:codebuild:ap-northeast-1:${var.aws_project_id}:report-group/${var.codebuild_project_name}-*"
    ]
  }
}

data "aws_iam_policy_document" "codebuild_secrets_manager" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:ap-northeast-1:${var.aws_project_id}:secret:/CodeBuild/*"]
  }
}

data "aws_iam_policy_document" "codebuild_cloudwatch_logs" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:ap-northeast-1:${var.aws_project_id}:log-group:${var.cloudwatch_group_name}",
      "arn:aws:logs:ap-northeast-1:${var.aws_project_id}:log-group:${var.cloudwatch_group_name}:*"
    ]
  }
}

data "aws_iam_policy_document" "codepipeline_service" {
  statement {
    actions   = ["iam:PassRole"]
    resources = ["*"]
    condition {
      test     = "StringEqualsIfExists"
      variable = "iam:PassedToService"
      values = [
        "cloudformation.amazonaws.com",
        "elasticbeanstalk.amazonaws.com",
        "ec2.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
  }

  statement {
    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetRepository",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "codestar-connections:UseConnection"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "elasticbeanstalk:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
      "lambda:ListFunctions"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "opsworks:CreateDeployment",
      "opsworks:DescribeApps",
      "opsworks:DescribeCommands",
      "opsworks:DescribeDeployments",
      "opsworks:DescribeInstances",
      "opsworks:DescribeStacks",
      "opsworks:UpdateApp",
      "opsworks:UpdateStack"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeStacks",
      "cloudformation:UpdateStack",
      "cloudformation:CreateChangeSet",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DescribeChangeSet",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:SetStackPolicy",
      "cloudformation:ValidateTemplate"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:BatchGetBuildBatches",
      "codebuild:StartBuildBatch"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "devicefarm:ListProjects",
      "devicefarm:ListDevicePools",
      "devicefarm:GetRun",
      "devicefarm:GetUpload",
      "devicefarm:CreateUpload",
      "devicefarm:ScheduleRun"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "servicecatalog:ListProvisioningArtifacts",
      "servicecatalog:CreateProvisioningArtifact",
      "servicecatalog:DescribeProvisioningArtifact",
      "servicecatalog:DeleteProvisioningArtifact",
      "servicecatalog:UpdateProduct"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "cloudformation:ValidateTemplate"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:DescribeImages"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "states:DescribeExecution",
      "states:DescribeStateMachine",
      "states:StartExecution"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "appconfig:StartDeployment",
      "appconfig:StopDeployment",
      "appconfig:GetDeployment"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "cwe" {
  statement {
    actions   = ["codepipeline:StartPipelineExecution"]
    resources = ["${var.codepipeline_arn}"]
  }
}
