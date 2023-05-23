resource "aws_instance" "my_sample_ec2" {
  # checkov:skip=CKV_AWS_8: ADD REASON
  ami           = "ami-03aefa83246f44ef2"
  instance_type = "t2.micro"
}

resource "aws_instance" "my_sample_ec3" {
  # checkov:skip=CKV_AWS_8: ADD REASON
  ami           = "ami-03aefa83246f44ef2"
  instance_type = "t2.micro"
}

