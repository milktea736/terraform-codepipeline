variable "aws_project_id" {
  type        = string
  description = "The project id"
}

variable "aws_region" {
  type        = string
  description = "The project region"
}

variable "codecommit_repo_name" {
  type        = string
  description = "CodeCommit repo name"
}

variable "codecommit_branch" {
  type        = string
  description = "The branch used to build project"
}

variable "codebuild_project_name" {
  type        = string
  description = "The name of CodeBuild project"
}

variable "codepipeline_project_name" {
  type        = string
  description = "The name of CodePipeline project"
}

variable "cloudwatch_group_name" {
  type        = string
  description = "The name of cloud watch group"
  default     = "codebuild-logs"
}

variable "cloudwatch_stream_name" {
  type        = string
  description = "The name of cloud watch stream"
}

variable "owner" {
  type        = string
  description = "Owner name in tag"
}
