provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Security group for Jenkins and Flask app"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_instance" {
  ami                    = "ami-085386e29e44dacd7"
  instance_type          = "t2.micro"
  key_name               = "aws-terraform"
  security_groups        = [aws_security_group.jenkins_sg.name]
  associate_public_ip_address = true

  user_data              = <<-EOF
                            #!/bin/bash
                            sudo yum update -y
                            sudo amazon-linux-extras enable java-openjdk11
                            sudo yum install java-17-amazon-corretto -y
                            sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
                            sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
                            sudo yum install -y jenkins
                            sudo systemctl enable jenkins
                            sudo systemctl start jenkins
                            sudo yum install -y git
                            EOF

  tags = {
    Name = "Jenkins-Instance"
  }
}

output "public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}
