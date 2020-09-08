terraform {
  required_version = "~> 0.12"
}

provider "aws" {
  version = "~> 3.0"
  region  = "eu-central-1"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "flamarion-hashicorp"
    key    = "tfstate/tfe-vpc.tfstate"
    region = "eu-central-1"
  }
}

variable "public_key" {
  type = string
}
resource "aws_key_pair" "tfe_key" {
  key_name   = "flamarion-tfe-lab-provider"
  public_key = var.public_key
}

resource "aws_instance" "tfe_instance" {
  count                  = 1
  ami                    = "ami-07d1bb89ff2dd50fe"
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnets_id[0]
  instance_type          = "t2.large"
  key_name               = aws_key_pair.tfe_key.key_name
  user_data              = ""

  root_block_device {
    volume_size = 50
  }
}
