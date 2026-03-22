resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id =  local.catalogue_subnet_id
  vpc_security_group_ids =[local.catalogue_sg_id]
  #iam_instance_profile = aws_iam_instance_profile.bastion.name

  tags = merge(
    {
        Name = "${var.project_name}-${var.env}-catalogue"
    },
    local.common_tags
  )
}

resource "terraform_data" "bootstrap-catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]

 connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.catalogue.private_ip
  }

 provisioner "file" {
  source = "bootstrap.sh"
  destination = "/tmp/bootstrap.sh"
 }

 provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh", #giving excute access
        "sudo sh /tmp/bootstrap.sh catalogue dev"
    ]
  }
}

