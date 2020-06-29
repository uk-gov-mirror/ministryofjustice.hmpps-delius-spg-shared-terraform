{
"Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "application-autoscaling:*",
            "cloudwatch:DescribeAlarms",
            "cloudwatch:PutMetricAlarm"
        ],
        "Resource": "*"
        },
        {
        "Effect": "Allow",
        "Action": [
            "ssm:GetParameter",
            "ssm:GetParameters",
            "kms:Decrypt"
        ],
        "Resource": [
            "arn:aws:ssm:${region}:${aws_account_id}:parameter/${project_name}-${environment_type}/${project_name}/weblogic/spg-domain/remote_broker_username",
            "arn:aws:ssm:${region}:${aws_account_id}:parameter/${project_name}-${environment_type}/${project_name}/weblogic/spg-domain/remote_broker_password"
        ]
       }
    ]
}
