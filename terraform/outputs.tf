output "ecr_repo" {
  value = {
    repository_name = aws_ecr_repository.xyz_demo.name
    arn             = aws_ecr_repository.xyz_demo.arn
    registry_id     = aws_ecr_repository.xyz_demo.registry_id
    repository_url  = aws_ecr_repository.xyz_demo.repository_url
  }
  description = "The ECR repository for storing xyzdemo container images."
}