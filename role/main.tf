variable "aws_project_id" {}
variable "cloudwatch_group_name" {}
variable "owner" {}
variable "codecommit_arn" {}
variable "codebuild_project_name" {}
variable "codepipeline_arn" {}

module "policy" {
  source                 = "../policy"
  aws_project_id         = var.aws_project_id
  cloudwatch_group_name  = var.cloudwatch_group_name
  owner                  = var.owner
  codecommit_arn         = var.codecommit_arn
  codebuild_project_name = var.codebuild_project_name
  codepipeline_arn       = var.codepipeline_arn
}

resource "aws_iam_role" "tf_role_codebuild" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "codebuild.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  managed_policy_arns  = module.policy.codebuild_arns
  max_session_duration = 3600
  name                 = "tf-codebuild-${var.owner}"
  path                 = "/service-role/"
  tags                 = { "owner" : var.owner }
}

resource "aws_iam_role" "tf_role_codepipeline" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "codepipeline.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  managed_policy_arns  = module.policy.pipeline_arn
  max_session_duration = 3600
  name                 = "tf-codepipeline-${var.owner}"
  path                 = "/service-role/"
  tags                 = { "owner" : var.owner }
}

resource "aws_iam_role" "tf_role_cwe" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "events.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  managed_policy_arns  = module.policy.cwe_arn
  max_session_duration = 3600
  name                 = "tf-cwe-${var.owner}"
  path                 = "/service-role/"
  tags                 = { "owner" : var.owner }
}
