output "user_id" {
  value = aws_iam_user.this.id
}

output "user_arn" {
  value = aws_iam_user.this.arn
}

output "catpics_bucket_name" {
  value = module.catpics.bucket_name
}
