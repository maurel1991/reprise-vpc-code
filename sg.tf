resource "aws_security_group" "sg" {
  name        = "webserver-sg"
  description = "allow_22 and 80"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "webserver-sg"
  }

  ingress {
    description = "allow 22"
    cidr_blocks = ["172.56.220.204/32"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    description = "allow 80"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  ingress {
    description = "allow 8080"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1" # semantically equivalent to all ports
  }
}

