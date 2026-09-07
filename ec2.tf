resource "aws_instance" "frontend" {
  ami                    = "ami-006f82a1d5a27da54"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public-sub[count.index].id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ecr.name

  user_data = <<-EOF
    #!/bin/bash

    apt-get update
    apt-get install -y docker.io awscli

    systemctl enable docker
    systemctl start docker

    if ! snap list amazon-ssm-agent >/dev/null 2>&1; then
    snap install amazon-ssm-agent --classic
    fi
    systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent

  EOF

  count = 2

  tags = {
    Name = "frontend-server"
  }
}


resource "aws_instance" "backend" {
  ami                    = "ami-006f82a1d5a27da54"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private-sub[count.index].id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ecr.name

  user_data = <<-EOF
    #!/bin/bash

    apt-get update
    apt-get install -y docker.io awscli

    systemctl enable docker
    systemctl start docker

    if ! snap list amazon-ssm-agent >/dev/null 2>&1; then
    snap install amazon-ssm-agent --classic
    fi
    systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent

  EOF

  count = 2

  tags = {
    Name = "backend-server"
  }
}