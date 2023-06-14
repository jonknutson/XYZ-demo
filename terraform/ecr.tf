resource "aws_ecr_repository" "xyz_demo" {
  name                 = "xyz-demo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}