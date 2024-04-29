
module "shared_vars" {
  source = "../shared_vars"
}

## Create VPC
resource "aws_vpc" "vpc-dr" {
  cidr_block = "${module.shared_vars.vpc-cidr}"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "project-dr"
  }
}

output "vpcdr" {
    value = "${aws_vpc.vpc-dr.id}"
  
}


# create internet gateway
resource "aws_internet_gateway" "internet-gateway" {
    vpc_id = aws_vpc.vpc-dr.id

    tags = {
        Name = "project-IG-DR"
    }
}

# create public subnet 1
resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.vpc-dr.id
    cidr_block = "${module.shared_vars.public-subnet-1-cidr}"
    availability_zone = "me-south-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "Public-1-drsultan-DR"
    }
}

output "publicsg1" {
  value = "${aws_subnet.public-subnet-1.id}"
}

# create public subnet 2
resource "aws_subnet" "public-subnet-2" {
    vpc_id = aws_vpc.vpc-dr.id
    cidr_block = "${module.shared_vars.public-subnet-2-cidr}"
    availability_zone = "me-south-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "Public-2-drsultan-DR"
    }
    }

output "publicsg2" {
  value = "${aws_subnet.public-subnet-2.id}"
}

#create route table and public route

resource "aws_route_table" "public-route-table"{
    vpc_id =aws_vpc.vpc-dr.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet-gateway.id
    }

    tags = {
        Name = "public-rt-drsultan-DR"
    }
}
#Associate public subnet 1 to "Public Route Table"

resource "aws_route_table_association" "public-subnet-1-route-table-association"{
    subnet_id = aws_subnet.public-subnet-1.id
    route_table_id = aws_route_table.public-route-table.id
  
}

#Associate public subnet 2 to "Public Route Table"

resource "aws_route_table_association" "public-subnet-2-route-table-association" {
    subnet_id = aws_subnet.public-subnet-2.id
    route_table_id = aws_route_table.public-route-table.id
}

#create Elastic IP
resource "aws_eip" "eip1"{
    vpc = true
}

resource "aws_eip" "eip2"{
    vpc = true
}

resource "aws_eip" "eip3"{
    vpc = true
}

#Create NAT Gateway1
resource "aws_nat_gateway" "nat-gateway1"{
    allocation_id = aws_eip.eip1.id
    subnet_id = aws_subnet.public-subnet-1.id
    tags = {
      "Name" = "nat-drsultan-DR1"
    }
}

#Create NAT Gateway2
resource "aws_nat_gateway" "nat-gateway2"{
    allocation_id = aws_eip.eip2.id
    subnet_id = aws_subnet.public-subnet-1.id
    tags = {
      "Name" = "nat-drsultan-DR2"
    }
}


#Create NAT Gateway3
resource "aws_nat_gateway" "nat-gateway3"{
    allocation_id = aws_eip.eip3.id
    subnet_id = aws_subnet.public-subnet-1.id
    tags = {
      "Name" = "nat-drsultan-DR3"
    }
}


#create Private subnet 1
resource "aws_subnet" "private-subnet-1" {
    vpc_id = aws_vpc.vpc-dr.id
    cidr_block = "${module.shared_vars.private-subnet-3-cidr}"
    availability_zone = "me-south-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "Private-1-drsultan-DR"
    }
    
}

output "privatesg1" {
  value = "${aws_subnet.private-subnet-1.id}"
}

#create Private subnet 2
resource "aws_subnet" "private-subnet-2" {
    vpc_id = aws_vpc.vpc-dr.id
    cidr_block = "${module.shared_vars.private-subnet-4-cidr}"
    availability_zone = "me-south-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "Private-2-drsultan-DR"
    }
    
}

output "privatesg2" {
  value = "${aws_subnet.private-subnet-2.id}"
}
#create Private subnet 3
resource "aws_subnet" "private-subnet-3" {
    vpc_id = aws_vpc.vpc-dr.id
    cidr_block = "${module.shared_vars.private-subnet-5-cidr}"
    availability_zone = "me-south-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "Private-3-ALM-DR"
    }
    
}

output "privatesg3" {
  value = "${aws_subnet.private-subnet-3.id}"
}

#create route table and private 

resource "aws_route_table" "private-route-table1"{
    vpc_id =aws_vpc.vpc-dr.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-gateway1.id
    }

    tags = {
        Name = "private-rt-drsutlant-DR1"
    }
}


#create route table and private 

resource "aws_route_table" "private-route-table2"{
    vpc_id =aws_vpc.vpc-dr.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-gateway2.id
    }

    tags = {
        Name = "private-rt-drsutlant-DR2"
    }
}

#create route table and private 

resource "aws_route_table" "private-route-table3"{
    vpc_id =aws_vpc.vpc-dr.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-gateway3.id
    }

    tags = {
        Name = "private-rt-drsutlant-DR3"
    }
}
#Associate private subnet 3 to "Private Route Table"

resource "aws_route_table_association" "private-subnet-3-route-table-association1"{
    subnet_id = aws_subnet.private-subnet-3.id
    route_table_id = aws_route_table.private-route-table1.id
  
}

#Associate public subnet 1 to "Public Route Table"

resource "aws_route_table_association" "private-subnet-2-route-table-association"{
    subnet_id = aws_subnet.private-subnet-2.id
    route_table_id = aws_route_table.private-route-table2.id
  
}

#Associate public subnet 1 to "Public Route Table"

resource "aws_route_table_association" "private-subnet-1-route-table-association"{
    subnet_id = aws_subnet.private-subnet-1.id
    route_table_id = aws_route_table.private-route-table3.id
  
}

