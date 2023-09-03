resource "aws_internet_gateway" "my_igw" {
  tags = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-igw"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-igw"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.vpc_id
  ]
}
