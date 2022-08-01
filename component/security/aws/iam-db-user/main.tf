resource "aws_iam_group" "iam_group" {
  name = var.group_name
}

resource "aws_iam_group_membership" "iam_group_membership" {
  name = "iam-group-membership-${var.name}"

  users = tolist(aws_iam_user.iam_user.*.name)

  group = aws_iam_group.iam_group.name
}

resource "aws_iam_group_policy_attachment" "policy_attachment" {
  group      = aws_iam_group.iam_group.name
  policy_arn = var.policy_arn
}

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
