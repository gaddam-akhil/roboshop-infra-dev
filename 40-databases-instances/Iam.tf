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
  policy      = file("Iam-policy-role")
}

# Attach the policy to the user
resource "aws_iam_role_policy_attachment" "mysql" {
  role       = aws_iam_role.mysql.name
  policy_arn = "arn:aws:ssm:us-east-1:601930231965:parameter/roboshop/dev/mysql_root_password" # Example ARN
  #arn:aws:ssm:us-east-1:601930231965:parameter/roboshop/dev/mysql_root_password
}

# iam_instance_profile
resource "aws_iam_instance_profile" "mysql" {
  name = "${var.project}-${var.environment}-mysql"
  role = aws_iam_role.mysql.name
}
