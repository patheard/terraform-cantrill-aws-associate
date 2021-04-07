output "user_id" {
  value = aws_iam_user.this.id
}

output "user_arn" {
  value = aws_iam_user.this.arn
}

output "user_name" {
  value = aws_iam_user.this.name
}

output "catpics_bucket_name" {
  value = module.catpics.bucket_name
}
