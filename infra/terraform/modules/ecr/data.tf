data "aws_iam_role" "access_role" {
  name  = "${element(var.role_access, count.index)}"
  count = "${length(var.role_access)}"
}