{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::723123699647:role/tf-eu-west-2-hmpps-delius-core-sandpit-spgw-mpx-int-ec2-role"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:eu-west-2:723123699647:domain/ndst-elk-audit-stack/*"
    }
  ]
}