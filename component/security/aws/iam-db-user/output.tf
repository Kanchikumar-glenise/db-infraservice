output "user_arn" {
  value       = aws_iam_user.iam_user.*.arn
  description = "User ARN"
}

output "group_arn" {
  value       = aws_iam_group.iam_group.arn
  description = "Group ARN"
}
