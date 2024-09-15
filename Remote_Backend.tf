terraform {
  backend "s3" {
    bucket         = "Replace_your_bucket_name"
    key            = "./terraform.tfstate"
    region         = "us-east-1"
  }
}
