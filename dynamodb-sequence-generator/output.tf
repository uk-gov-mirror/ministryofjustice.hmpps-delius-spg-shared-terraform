output "aws_dynamodb_table_name" {
  value = "${aws_dynamodb_table.sequence_generator_table.name}"
}

output "aws_dynamodb_table_arn" {
  value = "${aws_dynamodb_table.sequence_generator_table.arn}"
}
