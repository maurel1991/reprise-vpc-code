resource "aws_instance" "ec2" {
  ami             = "ami-0195204d5dce06d99"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg.id]
  subnet_id       = aws_subnet.Public1.id
  key_name        = aws_key_pair.pub_key.key_name
  associate_public_ip_address = true
  user_data = file("userdata.sh")
   tags = {
    key_name   = "utc-dev-ins"
    Team       = "cloud transformation"
    env        = "Dev"
    Created_by = "ola"
  }

}
# EBS volume
resource "aws_ebs_volume" "Vol_ebs" {
  availability_zone = aws_instance.ec2.availability_zone
  size              = "20"
  tags = {
    name = "EBS_vol"
  }
}
#attach volume EBS
resource "aws_volume_attachment" "Volume_att" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.Vol_ebs.id
  instance_id = aws_instance.ec2.id
}

# create key RSA by tls
resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
# key pair
resource "aws_key_pair" "pub_key" {
    key_name = "utc-key"
    public_key = tls_private_key.tls_key.public_key_openssh
}

resource "local_file" "priv_key" {
    filename= "utc-key.pem"
    content  = tls_private_key.tls_key.private_key_pem
}
    