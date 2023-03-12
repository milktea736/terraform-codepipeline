output "codecommit_link" {
  value = aws_codecommit_repository.tf_codecommit.clone_url_http
}

output "codecommit_branch" {
  value = var.codecommit_branch
}
