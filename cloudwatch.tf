resource "aws_cloudwatch_event_rule" "example" {
  description    = "Trigger CodePipeline when a change occurs in the AWS CodeCommit source repository and branch."
  event_bus_name = "default"
  name           = var.codepipeline_project_name
  event_pattern = jsonencode(
    {
      detail = {
        event = [
          "referenceCreated",
          "referenceUpdated",
        ]
        referenceName = [
          var.codecommit_branch,
        ]
        referenceType = [
          "branch",
        ]
      }
      detail-type = [
        "CodeCommit Repository State Change",
      ]
      resources = [
        aws_codecommit_repository.tf_codecommit.arn,
      ]
      source = [
        "aws.codecommit"
      ]
    }
  )
  is_enabled = true
  tags       = { "owner" : var.owner }
}

resource "aws_cloudwatch_event_target" "example" {
  rule     = aws_cloudwatch_event_rule.example.name
  arn      = aws_codepipeline.tf_codepipeline.arn
  role_arn = module.role.cwe_arn
}
