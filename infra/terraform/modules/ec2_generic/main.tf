resource "aws_instance" "generic" {

    security_groups   = data.aws_security_group.security_group.*.name
    count             = var.instance_count
    instance_type     = var.instance_type
    availability_zone = var.availability_zone
    key_name          = var.instance_key
    ami               = data.aws_ami.amazon_linux_2_ami.id
    
    iam_instance_profile = aws_iam_instance_profile.instance_profile.name

    tags = merge(var.instance_tags, {
        "Role"        = var.service_name,
        "Environment" = var.environment
    })
}

resource "aws_eip" "instance_ip" {
    instance = "${element(aws_instance.generic.*.id, count.index)}"
    count    = "${var.instance_count}"
    vpc      = true

  depends_on = [aws_instance.generic]
}

resource "aws_iam_role" "instance_role" {
    name = "${var.service_name}-Role"
    path = "/"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
    name = "${var.service_name}-instance-profile"
    role = aws_iam_role.instance_role.name
}