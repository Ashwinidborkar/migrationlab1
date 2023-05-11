terraform {
    backend "s3" {
        bucket = "migrationlab"
        key = "talent-academy/migrationlab/terraform.tfstate"
        region = "eu-central-1"
        dynamodb_table = "terraform-lock"
    }
}