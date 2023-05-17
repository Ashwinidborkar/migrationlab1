resource "aws_s3_bucket" "mymigrationlab1"{
    bucket = "migrationlab"

    tags = {
        Name = "migrationlab"
        Environment = "Lab"
    }
    lifecycle {
        prevent_destroy = false

    }
}

resource "aws_s3_bucket_versioning" "version_my_bucket" {
    bucket = aws_s3_bucket.mymigrationlab1.id

    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_dynamodb_table" "terraform_lock_tbl" {
  name           = "terraform-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags           = {
    Name = "terraform-lock"
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}


resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.mymigrationlab1.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}