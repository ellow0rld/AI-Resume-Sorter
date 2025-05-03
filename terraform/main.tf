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
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_instance" {
  ami                    = "ami-0db4215299a464a09" 
  instance_type          = "t2.micro"
  key_name               = "aws-terraform"  
  security_groups        = [aws_security_group.jenkins_sg.name]
  user_data              = <<-EOF
                            #!/bin/bash
                            sudo yum update -y
                            sudo yum install -y java-1.8.0-openjdk
                            sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
                            sudo rpm --import https://pkg.jenkins.io/jenkins.io.key
                            sudo yum install -y jenkins
                            sudo systemctl start jenkins
                            sudo systemctl enable jenkins
                            EOF

  tags = {
    Name = "Jenkins-Instance"
  }

  # Associate public IP
  associate_public_ip_address = true
}

output "public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}
