output "instance_ami" {
  value = aws_instance.web.ami
}

output "instance_arn" {
  value = aws_instance.web.arn
}

output "instance_az" {
  value = aws_instance.web.availability_zone
}


output "instance_id" {
  value = aws_instance.web.id
}

output "instance_instance_type" {
  value = aws_instance.web.instance_type
}