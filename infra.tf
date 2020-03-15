provider "aws" {
  region = "${var.region}"
  access_key = "AKIAIJMDIEQQEHFF4BCA"
  secret_key = "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" 
}

resource "aws_vpc" "prod" {
  cidr_block           = "${var.cidr_block}"
  instance_tenancy     = "${var.tenancy}"
  enable_dns_support   = "${var.dns}"
  enable_dns_hostnames = "${var.hostnames}"

  tags {
    Name  = "${var.tags}"
    stack = "${var.tags1}"
  }
}

resource "aws_subnet" "Publicsubnet" {
  count             = "${length(var.Public)}"
  vpc_id            = "${aws_vpc.prod.id}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,count.index)}"
  cidr_block        = "${element(var.Public,count.index)}"

  tags {
    Name  = "public-${var.tags1}"
    Stack = "${var.tags1}"
  }
}

resource "aws_subnet" "Privatesubnet" {
  count             = "${length(var.Private)}"
  vpc_id            = "${aws_vpc.prod.id}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,count.index)}"
  cidr_block        = "${element(var.Private,count.index)}"

  tags {
    Name  = "private-${var.tags1}"
    Stack = "${var.tags1}"
  }
}

resource "aws_internet_gateway" "igw" {
  count  = 1
  vpc_id = "${aws_vpc.prod.id}"

  tags {
    Name = "${var.tags1}"
  }
}

resource "aws_eip" "nat" {
  count = 1
  vpc   = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${element(aws_subnet.Publicsubnet.*.id, count.index)}"

  #vpc_id        = "${aws_vpc.prod.id}"

  tags = {
    Name = "nat"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.prod.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "public Subnet"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.prod.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw.id}"
  }

  tags {
    Name = "private Subnet"
  }
}
