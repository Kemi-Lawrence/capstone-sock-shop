terraform {
  backend "s3" {
    bucket         = "sock-shop-bucket-0906"
    key            = "terraform/key"
    region         = "eu-west-2"
    dynamodb_table = "terraform-lock"
  }
}