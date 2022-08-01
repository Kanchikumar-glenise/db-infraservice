resource "aws_iam_user" "iam_user" {
  count = length(var.users)
  name  = var.users[count.index]

  tags = merge(
    {
      Name = var.users[count.index],
    },
    var.tags
  )
}

resource "aws_iam_access_key" "iam_access_key" {
  count = length(var.users)
  user  = aws_iam_user.iam_user[count.index].name
}
