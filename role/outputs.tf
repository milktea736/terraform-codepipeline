output "codebuild_arn" {
  value = aws_iam_role.tf_role_codebuild.arn
}

output "codepipeline_arn" {
  value = aws_iam_role.tf_role_codepipeline.arn
}

output "cwe_arn" {
  value = aws_iam_role.tf_role_cwe.arn
}
