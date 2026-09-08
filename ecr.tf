resource "aws_ecr_repository" "frontend_image" {
  name         = "frontend-image"
  force_delete = true
  tags = {
    Name = "frontend-image"
  }
}

resource "aws_ecr_repository" "backend_image" {
  name         = "backend-image"
  force_delete = true
  tags = {
    Name = "backend-image"
  }
}