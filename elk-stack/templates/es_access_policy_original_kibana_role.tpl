{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:eu-west-2:723123699647:domain/ndst-elk-audit-stack/*"
    }
  ]
}{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAuthenticatedKibanaRoleAccess",
            "Effect":"Allow",
            "Principal": {
                "AWS": [
                    "${kibana_role}"

                ]
            },
            "Action":"es:*",
            "Resource":"arn:aws:es:${region}:${account_id}:domain/${domain}" 
        }
    ]
}