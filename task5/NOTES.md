## Task 5 - Bug Fix

There were two separate problems in the original configuration.

### 1. Incorrect principal ARN

The trust policy used:

    arn:aws:iam::000000000000:user/roleB

This is incorrect because `roleB` is an IAM role, not an IAM user.
The ARN therefore needs to use `role` instead of `user`:

    arn:aws:iam::000000000000:role/roleB

The trust policy controls who can assume roleC, so roleC must trust
the roleB role from Account A.

### 2. S3 permissions were too broad

The original permissions policy used:

    Action   = "s3:*"
    Resource = "*"

This gives roleC permissions over all S3 resources rather than limiting
access to the specific bucket required by the task.

I changed the Resource to the ARN of the specific S3 bucket and its
objects:

    arn:aws:s3:::my-build-artifacts-bucket
    arn:aws:s3:::my-build-artifacts-bucket/*

The first ARN refers to the bucket itself and the second refers to
objects inside the bucket.

Therefore, roleC can perform the specified S3 actions only against
the intended bucket rather than all S3 resources.
