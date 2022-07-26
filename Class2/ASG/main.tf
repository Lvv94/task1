# Pull all AZ from this region
data "aws_availability_zones" "all" {}

# This pulls AMI info from this region
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

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  name = "example-asg"

  min_size                  = 3
  max_size                  = 99
  desired_capacity          = 3
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  availability_zones	=  data.aws_availability_zones.all.names  # Use all AZs from this region

  # Launch template
  launch_template_name        = "example-asg"
  launch_template_description = "Launch template example"
  update_default_version      = true

  image_id          = data.aws_ami.ubuntu.id  # This uses AMI found in this region
  instance_type     = "t3.micro"
  ebs_optimized     = true
  enable_monitoring = true

}