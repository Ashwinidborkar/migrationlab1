resource "aws_instance" "my_sample_ec2" {
  ami           = "ami-09fd16644beea3565"
  instance_type = "t2.micro"
}