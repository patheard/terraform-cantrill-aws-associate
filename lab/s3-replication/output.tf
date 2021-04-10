output "source_bucket_name" {
  value = aws_s3_bucket.replication_source.id
}

output "destination_bucket_name" {
  value = aws_s3_bucket.replication_destination.id
}
