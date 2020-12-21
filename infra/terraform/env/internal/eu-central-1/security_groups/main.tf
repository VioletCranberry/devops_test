resource "aws_security_group" "common" {
  name        = "${var.environment}-common"
  description = "Common security group"

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

  tags = {
        Name = "${var.environment}-common"
    }
}

resource "aws_security_group" "frontend" {
  name        = "${var.environment}-frontend"
  description = "Frontend security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "${var.environment}-frontend"
  }
}

resource "aws_security_group" "backend" {
  name        = "${var.environment}-backend"
  description = "Backend security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  tags = {
      Name = "${var.environment}-backend"
  }
}
