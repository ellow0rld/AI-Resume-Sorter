provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "flask_app" {
  ami           = "ami-0db4215299a464a09"
  instance_type = "t2.micro"

  key_name = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y python3 git
              pip3 install flask
              EOF

  tags = {
    Name = "FlaskAppInstance"
  }
}

output "public_ip" {
  value = aws_instance.flask_app.public_ip
}
