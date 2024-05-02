# Terraform AWS VPC Module

This Terraform module deploys a Virtual Private Cloud (VPC) in AWS with configurable public and private subnetworks, Internet Gateway, route tables, and network ACLs.

## Features

- **VPC**: Provision a VPC to host all resources.
- **Internet Gateway**: Attach an Internet Gateway to enable communication between resources in your VPC and the internet.
- **Public Subnets**: Deploy between 1-3 public subnets, which are directly accessible from the internet.
- **Private Subnets**: Deploy between 1-3 private subnets, which are not directly accessible from the internet.
- **Route Tables**: One public route table for public subnets and up to three private route tables for private subnets.
- **Network ACLs**: One public and one private Network ACL for managing traffic into and out of the subnets.

## Usage

To use this module in your Terraform environment, add the following configuration to your Terraform script:

```hcl
module "vpc" {
  source = "github.com/oriol366/terraform-aws-vpc-module"

  // VPC CIDR
  cidr_block = "10.0.0.0/16"

  vpc_az_count = 3

  // Region
  region = "eu-central-1"

  // Tags to append to all resources created with this module
  tags = {
      Project = "Terraform-AWS-VPC-Module"
    }

  prefix = "tavm"
}
```

## Input Variables
- **cidr_block**: CIDR block for the VPC.
- **vpc_az_count**: A number between 1 to 3, specifying how many Availability Zones this VPC will use. It will deploy a private and a public subnet in each AZ.
- **region**: The region where this VPC will be created.
- **tags**: List of tags that will be appended to all resources created using this module.
- **prefix**: A prefix that will be appended to resources created in this VPC.

## Outputs
- **vpc_id**: The ID of the VPC.
- **public_subnet_ids**: List of IDs for the public subnets.
- **private_subnet_ids**: List of IDs for the private subnets.
- **internet_gateway_id**: The ID of the Internet Gateway.

## Providers
- **AWS**