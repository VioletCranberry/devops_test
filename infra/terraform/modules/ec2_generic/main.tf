resource "aws_instance" "generic" {

    security_groups   = data.aws_security_group.security_group.*.name
    count             = var.instance_count
    instance_type     = var.instance_type
    availability_zone = var.availability_zone
    key_name          = var.instance_key
    ami               = data.aws_ami.amazon_linux_2_ami.id

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
