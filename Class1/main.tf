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
