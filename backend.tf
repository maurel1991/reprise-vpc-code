terraform {
  backend "s3" {
    bucket         = "kevin-bucket01"
    key            = "cloud/terraformstatefile"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-bykev"
    encrypt        = true
  }

}