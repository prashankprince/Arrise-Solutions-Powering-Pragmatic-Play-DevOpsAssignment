resource "aws_iam_policy" "ci_pipeline" {
  provider = aws.account_a

  name        = "ci-pipeline-least-privilege"
  description = "Minimum permissions required by the CI pipeline."

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      # ------------------------------------------------------------
      # ECR: Push Docker images to ONE repository
      # ------------------------------------------------------------
      {
        Sid    = "EcrPushToSpecificRepository"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        Resource = "arn:aws:ecr:${var.aws_region}:${var.account_a_id}:repository/${var.ecr_repository_name}"
      },

      # ECR authentication/token
      {
        Sid    = "EcrAuthentication"
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },

      # ------------------------------------------------------------
      # ECS: Register task definition
      # ------------------------------------------------------------
      {
        Sid    = "RegisterTaskDefinition"
        Effect = "Allow"

        Action = [
          "ecs:RegisterTaskDefinition"
        ]

        Resource = "*"
      },

      # ------------------------------------------------------------
      # ECS: Deploy/update ONE specific service
      # ------------------------------------------------------------
      {
        Sid    = "UpdateSpecificEcsService"
        Effect = "Allow"

        Action = [
          "ecs:UpdateService"
        ]
        Resource = "arn:aws:ecs:${var.aws_region}:${var.account_a_id}:service/${var.ecs_cluster_name}/${var.ecs_service_name}"
      },

      # ------------------------------------------------------------
      # ECS: Read task/service information needed by deployment
      # ------------------------------------------------------------
      {
        Sid    = "ReadEcsDeploymentInformation"
        Effect = "Allow"

        Action = [
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition"
        ]

        Resource = "*"
      },

      # ------------------------------------------------------------
      # S3: Read build artifacts from ONE bucket
      # ------------------------------------------------------------
      {
        Sid    = "ReadBuildArtifacts"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]

        Resource = "arn:aws:s3:::${var.s3_artifacts_bucket_name}/*"
      },

      {
        Sid    = "ListBuildArtifactsBucket"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::${var.s3_artifacts_bucket_name}/*"
      }
    ]
  })
}
