resource "aws_ecr_repository" "xyz_demo" {
  name                 = local.project_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}