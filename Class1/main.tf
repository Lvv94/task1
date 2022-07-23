resource "aws_iam_user" "user1" {
  name = "user1"
}
resource "aws_iam_group" "evolvecyber" {
  name = "evolvecyber"
}


resource "aws_iam_group_membership" "evolvecyber" {
  name = "evolvecyber-group-membership"
  users = [
    aws_iam_user.user1.name
  ]
  group = aws_iam_group.evolvecyber.name
}



resource "aws_iam_user" "multiuser" {
  name = each.key
  for_each = toset([
    "bob",
    "sam",
    "lisa",
  ])
}
resource "aws_iam_group" "multigroup" {
  name = each.key
  for_each = toset([
    "Sales",
    "Marketing",
    "Billing",
  ])
}

resource "aws_key_pair" "evolvecyber" {
  key_name   = "evolvecyber-key"
  public_key = file("~/.ssh/id_rsa.pub")
}