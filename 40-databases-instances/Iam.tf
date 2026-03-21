resource "aws_iam_role" "mysql" {
  name = local.mysql_name_iam

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
    local.common_tags,
    {
        Name = local.mysql_name_iam
    }
  )
}

# Create the IAM policy resource
resource "aws_iam_policy" "mysql" {
  name        = local.mysql_name_policy
  description = "A policy for ec2 instance"
  policy      = file("policy-role-doc.json")
}

# Attach the policy to the user
resource "aws_iam_role_policy_attachment" "mysql" {
  role       = aws_iam_role.mysql.name
  policy_arn = aws_iam_policy.mysql.arn
}

# iam_instance_profile
resource "aws_iam_instance_profile" "mysql" {
  name = "${var.project_name}-${var.env}-mysql"
  role = aws_iam_role.mysql.name
}
