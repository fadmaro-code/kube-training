provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "free" {
  ami             = "ami-0dba2cb6798deb6d8"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.fadmaro.key_name
  security_groups = [aws_security_group.allow_all.name]
}
