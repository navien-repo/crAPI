data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "crapi" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.crapi.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.instance.name

  user_data_replace_on_change = true
  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    crapi_repo_ref         = var.crapi_repo_ref
    crapi_repo_url         = var.crapi_repo_url
    crapi_version          = var.crapi_version
    reset_interval_minutes = var.reset_interval_minutes
  })

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_gb
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    Name = "${var.name_prefix}-ec2"
  }
}

resource "aws_eip" "crapi" {
  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-eip"
  }
}

resource "aws_eip_association" "crapi" {
  allocation_id = aws_eip.crapi.id
  instance_id   = aws_instance.crapi.id
}
