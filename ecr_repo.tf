resource "aws_ecr_repository" "example_app" {
  name = "example-app"
}

resource "aws_ecr_repository" "universe_deploy" {
  name = "universe/deploy"
}

resource "aws_ecr_lifecycle_policy" "example_ecr_lifecycle" {
  repository = aws_ecr_repository.example_app.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 5 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
    }]
  })
}
