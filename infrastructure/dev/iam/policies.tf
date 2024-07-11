resource "aws_iam_policy" "aws_lambda_upload_policy" {
  name = "presignedUrl-upload-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "lambda:InvokeFunction",
        "Resource" : "arn:aws:lambda:us-east-1:${var.account_id}:function:getPresignedUrl"
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:PutObject",
        "Resource" : "arn:aws:s3:::${var.input_bucket}/*"
      }
    ]
  })
}

resource "aws_iam_policy" "aws_lambda_execution_policy" {
  name = "lambda-execution-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "logs:CreateLogGroup",
        "Resource" : "arn:aws:logs:us-east-1:${var.account_id}:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/lambda/getPresignedUrl:*",
          "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/lambda/getOutputData:*",
          "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/lambda/deleteResultItems:*",
          "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/lambda/video-splitting:*",
          "arn:aws:logs:us-east-1:${var.account_id}:log-group:/aws/lambda/face-recognition:*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "aws_lambda_get_object_policy" {
  name = "get-object-data-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.output_bucket}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.output_bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "aws_lambda_delete_object_policy" {
  name = "delete-object-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.output_bucket}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.output_bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "aws_s3_full_access_policy" {
  name = "s3FullAccess"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*",
          "s3-object-lambda:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "aws_lambda_full_access_policy" {
  name = "Lambda-Full-Access"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudformation:DescribeStacks",
          "cloudformation:ListStackResources",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "kms:ListAliases",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListRolePolicies",
          "iam:ListRoles",
          "lambda:*",
          "logs:DescribeLogGroups",
          "states:DescribeStateMachine",
          "states:ListStateMachines",
          "tag:GetResources",
          "xray:GetTraceSummaries",
          "xray:BatchGetTraces"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:PassedToService" : "lambda.amazonaws.com"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:log-group:/aws/lambda/*"
      }
    ]
  })
}

