provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "resume_app" {
  ami           = "ami-0db4215299a464a09"
  instance_type = "t2.micro"
  key_name      = "aws-terraform"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              docker run -d -p 5000:5000 your-dockerhub-username/ai-resume-sorter
              EOF

  tags = {
    Name = "ResumeSorterApp"
  }

  vpc_security_group_ids = [aws_security_group.resume_sg.id]
}

resource "aws_security_group" "resume_sg" {
  name        = "resume_sg"
  description = "Allow HTTP and SSH"
  ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
