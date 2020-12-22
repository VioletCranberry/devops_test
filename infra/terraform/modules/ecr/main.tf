resource "aws_ecr_repository" "ecr_repo" {
    name                 = "${var.environment}-${var.ecr_name}"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
      scan_on_push = true
    }
    tags = {
        "Name" = "${var.environment}-${var.ecr_name}",
        "Environment" = var.environment
    }
}

resource "aws_iam_policy" "ecr_access_repo_policy" {
    name        = "${var.environment}-${var.ecr_name}-ecr-policy"
    description = "ECR ${var.ecr_name} PowerUser"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource",
                "ecr:DescribeImageScanFindings",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role-attach" {
  role       = "${element(data.aws_iam_role.access_role.*.name, count.index)}"
  policy_arn = aws_iam_policy.ecr_access_repo_policy.arn
  count      = "${length(var.role_access)}"
}

resource "aws_ecr_lifecycle_policy" "ecr_repo_policy" {
    repository = aws_ecr_repository.ecr_repo.name
    policy    = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 5
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
