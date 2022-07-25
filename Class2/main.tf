data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}




resource "aws_key_pair" "evolvecyber" {
  key_name_prefix   = "evolvecyber-key"
  public_key = file("~/.ssh/id_rsa.pub")
}



resource "aws_instance" "web" {
    #   count = 5
    #   associate_public_ip_address = false
    #   availability_zone = "us-east-1a"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.evolvecyber.key_name
}