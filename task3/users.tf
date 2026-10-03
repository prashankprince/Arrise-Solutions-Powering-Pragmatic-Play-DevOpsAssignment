resource "aws_iam_group" "group1" {
  provider = aws.account_a
  name     = "group1"
}

resource "aws_iam_user" "engine" {
  provider = aws.account_a
  name     = "engine"
}

resource "aws_iam_user" "ci" {
  provider = aws.account_a
  name     = "ci"
}

resource "aws_iam_user_group_membership" "group1_members" {
  provider = aws.account_a

  user = [
    aws_iam_user.engine.name,
    aws_iam_user.ci.name
  ]

  groups = [
    aws_iam_group.group1.name
  ]
}
