resource "aws_ecr_repository" "frontend_image" {
  name = "frontend-image"
  tags = {
    Name = "frontend-image"
  }
}

resource "aws_ecr_repository" "backend_image" {
  name = "backend-image"
  tags = {
    Name = "backend-image"
  }
}