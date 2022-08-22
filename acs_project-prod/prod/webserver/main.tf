
#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Remote state to retrieve network data
data "terraform_remote_state" "network" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "dev-acs730-project-group13" // Bucket from where to GET Terraform State
    key    = "${var.env}/network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                            // Region where bucket created
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  default_tags = merge(module.global_variables.default_tags, { "env" = var.env })
  prefix       = module.global_variables.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

# Retrieve global variables from the Terraform module
module "global_variables" {
  source = "/home/ec2-user/environment/modules/global_variables"
}

# webserver EC2 instance
resource "aws_instance" "webserver" {
  count                       = var.ec2_count
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.dev_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.private_subnet[count.index]
  security_groups             = [aws_security_group.webserver_sg.id]
  associate_public_ip_address = true
  user_data = file("${path.module}/httpd.sh",
  )


  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-webserver-${count.index + 1}"
    }
  )
}


# Adding SSH key to Amazon EC2
resource "aws_key_pair" "dev_key" {
  key_name   = local.name_prefix
  public_key = file("dev-key.pub")
}


# Security Group (webserver)
resource "aws_security_group" "webserver_sg" {
  name        = "allow_http_ssh_webserver"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc



  ingress {
    description     = "SSH-Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  ingress {
    description     = "HTTP-ELB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-webserver-sg"
    }
  )
}

# elb module

module "elb" {
  source          = "/home/ec2-user/environment/modules/elb"
  default_tags    = var.default_tags
  env             = var.env
  vpc_id          = data.terraform_remote_state.network.outputs.vpc
  security_groups = [aws_security_group.lb_sg.id]
  subnets         = data.terraform_remote_state.network.outputs.public_subnet[*]
  prefix          = var.prefix
  
}

resource "aws_security_group" "lb_sg" {
  name        = "allow_http_lb"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    description      = "HTTP from everywhere"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-lb-sg"
    }
  )
}



# Bastion host EC2 instance
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.dev_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet[1]
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  
  
  lifecycle {
    create_before_destroy = true
  }
   user_data = file("${path.module}/httpd.sh",
   )
 
}
# Security Group (Bastion)
resource "aws_security_group" "bastion_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_public_ip}/32", "${var.my_private_ip}/32"]
  }
  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["${var.my_private_ip}/32", "${var.my_public_ip}/32"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "sg-bastion-${local.name_prefix}"
    }
  )
}

# Auto-Scaling Group module

module "asg" {
  source              = "/home/ec2-user/environment/modules/asg"
  default_tags        = var.default_tags
  env                 = var.env
  desired_size        = var.desired_size
  instance_type       = var.instance_type
  public_key          = aws_key_pair.dev_key.key_name
  prefix              = var.prefix
  security_groups     = [aws_security_group.webserver_sg.id]
  vpc             = data.terraform_remote_state.network.outputs.vpc
  lb_target_group_arn = module.elb.target_group_arns
  vpc_zone_identifier = data.terraform_remote_state.network.outputs.private_subnet
}