resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id =  local.private_subnet_id
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

resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
   depends_on = [terraform_data.bootstrap-catalogue]
} 

resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project_name}-${var.env}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [aws_ec2_instance_state.catalogue]

  tags = merge(
    {
        Name = "${var.project_name}-${var.env}-catalogue"
    },
    local.common_tags
  )
}

resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project_name}-${var.env}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60

  health_check  {
    #enabled = true
    healthy_threshold = 2
    interval = 10
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 2
    unhealthy_threshold = 2
  }
}

resource "aws_launch_template" "catalogue" {
  name = "${var.project_name}-${var.env}-catalogue"
  image_id = aws_ami_from_instance.catalogue.id

  # once auto scaling sees less traffic, it will terminate the instance
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]

   # each time we apply terraform this version will be updated as default
  update_default_version = true

  #Tags for instance created by launch template to auto scaling
  tag_specifications {
    resource_type = "instance"
    
     tags = merge(
    {
        Name = "${var.project_name}-${var.env}-catalogue"
    },
    local.common_tags,
    {
        Description = "Tags for instance created by launch template to auto scaling"
    }
  )
  }
  
  #Tags for volume created by instances
  tag_specifications {
    resource_type = "volume"
    
    tags = merge(
    {
        Name = "${var.project_name}-${var.env}-catalogue"
    },
    local.common_tags,
    {
        Description = "Tags for volume created by instances"
    }
  )
  }
  # Launch template tags
  tags = merge(
    {
        Name = "${var.project_name}-${var.env}-catalogue"
    },
    local.common_tags,
    {
        Description = "Tags for launch template"
    }
  )

}

resource "aws_autoscaling_group" "catalogue" {
  name                      = "${var.project_name}-${var.env}-catalogue"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = false
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = "$Latest"
  }
  
  vpc_zone_identifier = [local.private_subnet_id]
  target_group_arns = [aws_lb_target_group.catalogue.arn]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

 #use dynamic group by yourself
  dynamic "tag" {
    for_each = merge(
        {
            
            Name = "${var.project_name}-${var.env}-catalogue"
        },
        local.common_tags
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

 # with in 15min autoscaling should be successful
  timeouts {
    delete = "15m"
  }
}  

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  name                   = "${var.project_name}-${var.env}-catalogue"
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 120

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
} 

# This depends on target group
resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 70

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-alb-${var.env}.${var.domain_name}"]
    }
  }
} 

resource "terraform_data" "catalogue_delete" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  depends_on = [aws_autoscaling_policy.catalogue]
  
  # it executes in bastion
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id} "
  }
}