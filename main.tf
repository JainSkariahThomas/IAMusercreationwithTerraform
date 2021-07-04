terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
resource "aws_iam_user" "learnfromskill" {
  name = "Trainingsession"
  path = "/"
  force_destroy = true

  tags = {
    tag-key = "skillIAM"
  }
}
resource "aws_iam_group" "learngroup" {
    name = "groupexam"
}
resource "aws_iam_group_membership" "learngroup" {
  name  = "Jainstart"
  users = ["${aws_iam_user.learnfromskill.name}"]
  group = "${aws_iam_group.learngroup.name}"
}
resource "aws_iam_access_key" "learnfromskill" {
  user = aws_iam_user.learnfromskill.name
}
resource "aws_iam_user_login_profile" "learnfromskill" {
  user    = "${aws_iam_user.learnfromskill.name}"
  pgp_key = "keybase:jainthomas"
}

output "password" {
  value = aws_iam_user_login_profile.learnfromskill.encrypted_password
}
resource "aws_iam_user_policy" "learnfromskill_ro" {
  name = "test"
  user = aws_iam_user.learnfromskill.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEquals": {
                    "ec2:Region": "us-east-2"
                }
            }
        }
    ]
}
EOF
}
