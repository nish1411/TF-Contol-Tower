provider "aws" {
  region = "ap-southeast-1"
}


terraform {
  backend "s3" {
    bucket         = "my-uniquea-tfapse"
    key            = "newlz/tfstate"
    region         = "ap-southeast-1"
    #dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}