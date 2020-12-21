data "aws_ami" "amazon_linux_2_ami" {
    most_recent = true
    owners       = ["137112412989"]

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name   = "name"
        values = ["amzn2-ami-hvm*"]
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }

}

data "aws_security_group" "security_group" {
    name = "${element(var.security_groups, count.index)}"
    count = "${length(var.security_groups)}"
}
