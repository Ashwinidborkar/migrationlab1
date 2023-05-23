resource "aws_instance" "my_sample_ec2" {
  ami           = "ami-03aefa83246f44ef2"
  instance_type = "t2.micro"
}