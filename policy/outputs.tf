output "codebuild_arns" {
  value = [
    for policy in [
      aws_iam_policy.tf_codebuild_base_policy,
      aws_iam_policy.tf_policy_allow_login_ecr,
      aws_iam_policy.tf_policy_allow_push_ecr,
      aws_iam_policy.tf_codebuild_secrets_manager,
      aws_iam_policy.tf_codebuild_cloudwatch_logs,
    ] : policy.arn
  ]
}

output "pipeline_arn" {
  value = [
    for policy in [aws_iam_policy.tf_codepipeline_service, aws_iam_policy.tf_codebuild_base_policy, ]
    : policy.arn
  ]
}

output "cwe_arn" {
  value = [aws_iam_policy.tf_cwe.arn]
}
