{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchGetItem",
                "dynamodb:GetItem",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:BatchWriteItem",
                "dynamodb:PutItem",
                "dynamodb:UpdateItem",
                "dynamodb:CreateTable"
            ],
            "Resource": "arn:aws:dynamodb:${region}:${current_account_id}:table/${environment}-spg-scr-sequence"
        }
    ]
}
