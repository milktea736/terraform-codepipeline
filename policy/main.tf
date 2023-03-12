variable "owner" {}

resource "aws_iam_policy" "tf_codebuild_base_policy" {
  name        = "${var.owner}-codebuild_base_policy"
  path        = "/"
  description = "base policies for CodeBuild project"
  tags        = { "owner" : var.owner }
  policy      = data.aws_iam_policy_document.codebuild_base_policy.json
}

resource "aws_iam_policy" "tf_policy_allow_login_ecr" {
  name        = "${var.owner}-allow-login-ecr"
  path        = "/"
  description = "allow login to ecr"
  tags        = { "owner" : var.owner }
  policy      = data.aws_iam_policy_document.allow_login_ecr.json
}

resource "aws_iam_policy" "tf_policy_allow_push_ecr" {
  name        = "${var.owner}-allow-push-ecr"
  path        = "/"
  description = "allow push to ecr"
  tags        = { "owner" : var.owner }
  policy      = data.aws_iam_policy_document.allow_push_ecr.json
}

resource "aws_iam_policy" "tf_codebuild_secrets_manager" {
  name        = "${var.owner}-codebuild_secrets_manager"
  path        = "/"
  description = "allow get secret values from secret manager"
  tags        = { "owner" : var.owner }
  policy      = data.aws_iam_policy_document.codebuild_secrets_manager.json
}

resource "aws_iam_policy" "tf_codebuild_cloudwatch_logs" {
  name        = "${var.owner}-codebuild_cloud_watch_logs"
  path        = "/"
  description = "allow to use CloudWatch "
  tags        = { "owner" : var.owner }
  policy      = data.aws_iam_policy_document.codebuild_cloudwatch_logs.json
}

resource "aws_iam_policy" "tf_codepipeline_service" {
  name        = "${var.owner}-codepipeline_service"
  path        = "/"
  description = "allow to codepipeline permissions"
  tags        = { "owner" : var.owner }
  policy      = data.aws_iam_policy_document.codepipeline_service.json
}

resource "aws_iam_policy" "tf_cwe" {
  name        = "${var.owner}-cwe"
  path        = "/"
  description = "Allow cloud watch event to start CodePipeline"
  tags        = { "owner" : var.owner }
  policy      = data.aws_iam_policy_document.cwe.json
}
