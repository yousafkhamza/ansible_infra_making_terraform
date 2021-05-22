#------------------------------------------------------
# Creating KeyPair
#------------------------------------------------------

resource "aws_key_pair" "keypair" {
  key_name   = "ansible"
  public_key = file("ansi.pub")
  tags = {
    Name = "ansible"
  }
}

#------------------------------------------------------
# Security group for master
#------------------------------------------------------
resource "aws_security_group" "ssh-master" {
  name        = "sshmaster"
  description = "Allow 22"

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
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

  tags = {
    Name = "master"
  }
    lifecycle {
    create_before_destroy = true
  }
}

#------------------------------------------------------
# Security group for client
#------------------------------------------------------
resource "aws_security_group" "lamp-client" {
  name        = "lampclient"
  description = "Allow 22,80,443,3306"

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
    ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
    ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
    ingress {
    description      = "MySQL"
    from_port        = 3306
    to_port          = 3306
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

  tags = {
    Name = "clients"
  }
    lifecycle {
    create_before_destroy = true
  }
}

#------------------------------------------------------
# Ubuntu AMI choosing through data resource
#------------------------------------------------------
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

#------------------------------------------------------
# Amazon linux AMI choosing through data resource
#------------------------------------------------------
data "aws_ami" "linux" {
  most_recent = true

   filter {
   name   = "owner-alias"
   values = ["amazon"]
 }

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
owners = ["137112412989"] # Canonical

}

#------------------------------------------------------
# Create A ansible client one server
#------------------------------------------------------

resource "aws_instance" "client-one-ub" {
  count                        = var.env == "ubuntu" ? 1 : 0
  ami                          = data.aws_ami.ubuntu.id
  instance_type                = var.ctype
  key_name                     = aws_key_pair.keypair.id
  associate_public_ip_address  = true
  vpc_security_group_ids       = [ aws_security_group.lamp-client.id ]
  tags = {
    Name = "client-one"
  }

}

resource "aws_instance" "client-one-li" {
  count                        = var.env == "linux" ? 1 : 0
  ami                          = data.aws_ami.linux.id
  instance_type                = var.ctype
  key_name                     = aws_key_pair.keypair.id
  associate_public_ip_address  = true
  vpc_security_group_ids       = [ aws_security_group.lamp-client.id ]
  tags = {
    Name = "client-one"
  }

}

#------------------------------------------------------
# Create A ansible Client two server
#------------------------------------------------------
resource "aws_instance" "client-two-li" {
  
  count                        = var.env == "linux" ? 1 : 0
  ami                          = data.aws_ami.linux.id
  instance_type                = var.ctype
  key_name                     = aws_key_pair.keypair.id
  associate_public_ip_address  = true
  vpc_security_group_ids       = [ aws_security_group.lamp-client.id ]
  tags = {
    Name = "client-two"
  }

}

resource "aws_instance" "client-two-ub" {
  
  count                        = var.env == "ubuntu" ? 1 : 0
  ami                          = data.aws_ami.ubuntu.id
  instance_type                = var.ctype
  key_name                     = aws_key_pair.keypair.id
  associate_public_ip_address  = true
  vpc_security_group_ids       = [ aws_security_group.lamp-client.id ]
  tags = {
    Name = "client-two"
  }

}

#------------------------------------------------------
# Create A ansible Master server
#------------------------------------------------------
resource "aws_instance" "master" {
    
  ami                          = data.aws_ami.linux.id
  instance_type                = var.mtype
  key_name                     = aws_key_pair.keypair.id
  associate_public_ip_address  = true
  iam_instance_profile         = "EC2toS3"
  user_data 				           = file("userdata.sh")
  vpc_security_group_ids       = [ aws_security_group.ssh-master.id ]
  tags = {
    Name = "master"
  }
}

