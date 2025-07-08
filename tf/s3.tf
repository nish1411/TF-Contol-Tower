provider "aws" {
  region = "ap-southeast-1"
}


terraform {
  backend "s3" {
    bucket         = "388762879711-organizationcloudtrail"
    key            = "new/tfstate"
    region         = "us-east-1"
    #dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}