resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.client}.${var.project} VPC"
    Client = "${var.client}"
    Project = "${var.project}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.environment}"
  }

}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "eu-west-1a"

  tags {
    Name = "${var.client}.${var.project} Frontend Public Subnet"
    Client = "${var.client}"
    Project = "${var.project}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.environment}"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "eu-west-1b"

  tags {
    Name = "${var.client}.${var.project} Backend Private Subnet"
    Client = "${var.client}"
    Project = "${var.project}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.environment}"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.client}.${var.project} VPC IGW"
    Client = "${var.client}"
    Project = "${var.project}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.environment}"
  }
}

# Define the route table
resource "aws_route_table" "frontend-public-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "${var.client}.${var.project} Frontend Subnet RT"
    Client = "${var.client}"
    Project = "${var.project}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.environment}"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "frontend-public-rt" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.frontend-public-rt.id}"
}

# Define the security group for public subnet
resource "aws_security_group" "frontendsg" {
  name = "vpc_frontend_sg"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.default.id}"

  tags {
    Name = "${var.client}.${var.project} Front End SG"
    Client = "${var.client}"
    Project = "${var.project}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.environment}"
  }
}

# Define the security group for private subnet
resource "aws_security_group" "backendsg"{
  name = "vpc_backend_sg"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.client}.${var.project} Backend SG"
    Client = "${var.client}"
    Project = "${var.project}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.environment}"
  }
}

#create nat gw to allow private subnet internet access
resource "aws_eip" "nat_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.gw"]

  tags {
    Name = "${var.client}.${var.project} eip"
    Client = "${var.client}"
    Project = "${var.project}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.environment}"
  }
}

resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.nat_eip.id}"
    subnet_id = "${aws_subnet.public-subnet.id}"
    depends_on = ["aws_internet_gateway.gw"]

  tags {
    Name = "${var.client}.${var.project} nat gw"
    Client = "${var.client}"
    Project = "${var.project}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.environment}"
  }

}

resource "aws_route_table" "private_route_table" {
    vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.client}.${var.project} Private route table"
    Client = "${var.client}"
    Project = "${var.project}"
    CostCenter = "${var.costcenter}"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "private_route" {
	route_table_id  = "${aws_route_table.private_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.nat.id}"
}
# route tables associations
resource "aws_route_table_association" "private_subnet" {
    subnet_id = "${aws_subnet.private-subnet.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}

