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
  key_name_prefix = "evolvecyber-key"
  public_key      = file("~/.ssh/id_rsa.pub")
  tags            = local.common_tags

}

resource "aws_security_group" "terraform-allow_tls" {
  name        = "terraform-allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags

}


resource "aws_instance" "web" {
  #   count = 5
  #   associate_public_ip_address = false
  availability_zone      = "us-east-1a"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.evolvecyber.key_name
  user_data              = file("wordpress.sh")
  vpc_security_group_ids = [aws_security_group.terraform-allow_tls.id]
  tags                   = local.common_tags

}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 100
  tags              = local.common_tags

}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.web.id
}