provider "aws" {
 region = "us-east-1"
}

data "aws_ami" "centos" {
  filter {
  name = "root-device-type"
  values = ["ebs"]
}
filter {
name   = "name"
values = ["CentOS Linux 7 x86_64 HVM EBS *"]
}
  most_recent = true
  owners = ["679593333241"]

}

output "ami" {
  value = "${data.aws_ami.centos.id}"
}

resource "aws_key_pair" "towerkey" {
key_name   = "towerkey"
public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.towerkey.key_name
  provisioner "remote-exec" {
       connection {
       host = self.public_ip
       type = "ssh"
       user = "centos"
       private_key = file(var.ssh_key_location)
       }
       inline = ["sudo yum install -y epel-release",]
     } 

  tags = {
    Name = "HelloWorld"
  }
}