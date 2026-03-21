# mongodb instance
resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id =  local.database_subnet_id
  vpc_security_group_ids =[local.mongodb_sg_id]
  #iam_instance_profile = aws_iam_instance_profile.bastion.name

  tags = merge(
    {
        Name = "${var.project_name}-${var.env}-mongodb"
    },
    local.common_tags
  )
}

resource "terraform_data" "bootstrap-mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]

 connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
  }

 provisioner "file" {
  source = "bootstrap.sh"
  destination = "/tmp/bootstrap.sh"
 }

 provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh", #giving excute access
        "sudo sh /tmp/bootstrap.sh mongodb"
    ]
  }
}

# redis instance 
resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id =  local.database_subnet_id
  vpc_security_group_ids =[local.redis_sg_id]
  #iam_instance_profile = aws_iam_instance_profile.bastion.name

  tags = merge(
    {
        Name = "${var.project_name}-${var.env}-redis"
    },
    local.common_tags
  )
}

 
resource "terraform_data" "bootstrap_redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]

 connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.redis.private_ip
  }

 provisioner "file" {
  source = "bootstrap.sh" #local file path
  destination = "/tmp/bootstrap.sh" #destination file path
 }

 provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh", #giving excute access
        "sudo sh /tmp/bootstrap.sh redis"
    ]
  }
}

# mysql instance 
resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id =  local.database_subnet_id
  vpc_security_group_ids =[local.mysql_sg_id]
  iam_instance_profile = aws_iam_instance_profile.mysql.name

  tags = merge(
    {
        Name = "${var.project_name}-${var.env}-mysql"
    },
    local.common_tags
  )
}

 
resource "terraform_data" "bootstrap_mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]

 connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mysql.private_ip
  }

 provisioner "file" {
  source = "bootstrap.sh" #local file path
  destination = "/tmp/bootstrap.sh" #destination file path
 }

 provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh", #giving excute access
        "sudo sh /tmp/bootstrap.sh mysql ${var.env}"
    ]
  }
}

