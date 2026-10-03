# Task 4 - Least-Privilege CI Policy

## Purpose

The `ci` IAM user receives a custom policy containing only the
permissions required by the CI pipeline.

The pipeline needs to:

1. Push Docker images to one ECR repository.
2. Register ECS task definitions and update one ECS service.
3. Read build artifacts from one S3 bucket.

## ECR Permissions

The policy allows:

- `ecr:GetAuthorizationToken`
- `ecr:BatchCheckLayerAvailability`
- `ecr:CompleteLayerUpload`
- `ecr:InitiateLayerUpload`
- `ecr:PutImage`
- `ecr:UploadLayerPart`

The image upload permissions are restricted to the specific ECR
repository used by the application.

`ecr:GetAuthorizationToken` uses `Resource = "*"` because AWS does
not support resource-level permissions for that action.

## ECS Permissions

The policy allows:

- `ecs:RegisterTaskDefinition`
- `ecs:UpdateService`
- `ecs:DescribeServices`
- `ecs:DescribeTaskDefinition`

`ecs:UpdateService` is restricted to the specific ECS service.

`ecs:RegisterTaskDefinition` uses `Resource = "*"` because this
action does not support restricting the resource to one specific
task-definition ARN.

## S3 Permissions

The policy allows the CI pipeline to read build artifacts from one
specific S3 bucket.

It allows:

- `s3:GetObject`
- `s3:GetObjectVersion`
- `s3:ListBucket`

The policy deliberately does NOT grant:

- `s3:PutObject`
- `s3:DeleteObject`
- `s3:DeleteBucket`
- `s3:PutBucketPolicy`
- `s3:PutBucketVersioning`

Therefore the CI pipeline cannot modify or delete the build artifacts.

## Deliberately Excluded Permissions

The policy does not use broad managed policies such as:

- `PowerUserAccess`
- `AdministratorAccess`
- `AmazonEC2ContainerRegistryFullAccess`
- `AmazonECSFullAccess`
- `AmazonS3FullAccess`

These would grant permissions beyond what the CI pipeline needs.

The policy also deliberately excludes unrelated services such as EC2,
IAM, Lambda, RDS, DynamoDB, CloudFormation, and other AWS services.

The goal is to follow least privilege: the `ci` user receives only
the permissions required for the defined CI/CD operations.
