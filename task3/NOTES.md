# Task 3 - Multi-Account IAM and Cross-Account Access

## Account A

Account A is `000000000000`.

It contains:

- `group1`
  - `engine`
  - `ci`
- `group2`
  - `alice`
  - `bob`
- `roleA`
- `roleB`

`group1` users are configured for programmatic access using access
keys and do not have IAM console passwords.

`group2` users have console login credentials and access keys.

## Account B

Account B is `111111111111`.

It contains:

- `roleC`
- One named S3 bucket

`roleC` trusts only the specific `roleB` ARN from Account A.

`roleC` has `s3:*` permissions only against the specified S3 bucket
and its objects.

## 1. Would I give engine and ci IAM users with access keys in production?

Generally, no.

For a real production environment, I would prefer short-lived
credentials and IAM roles rather than long-lived IAM user access keys
where possible.

For human users, I would generally use AWS IAM Identity Center
(or an external identity provider) and assign users/groups to roles.

For workloads such as CI/CD, I would prefer workload identity or
federation, such as OIDC, so that the CI system can obtain temporary
AWS credentials without storing a long-lived AWS access key and
secret key.

IAM users with access keys are used here because the assignment
specifically asks for IAM users and CLI/programmatic access.

AWS recommends temporary credentials where possible and recommends
IAM Identity Center for workforce users in multi-account environments.

## 2. Why does roleC trust roleB's ARN instead of Account A root?

The trust policy controls who is trusted to assume roleC.

If roleC trusts:

    arn:aws:iam::000000000000:root

the trust relationship is with Account A as a whole. This is broader
than explicitly naming roleB because other principals in Account A
could potentially be authorized to assume roleC if they are given
the required `sts:AssumeRole` permission.

Instead, roleC trusts:

    arn:aws:iam::000000000000:role/roleB

This explicitly identifies roleB as the trusted principal.

This is important because the requirement is that roleC must be
assumable by roleB, and not by other principals in Account A.

The resulting access path is:

    engine/ci
        |
        v
      roleB
        |
        | sts:AssumeRole
        v
      roleC
        |
        v
    specific S3 bucket
