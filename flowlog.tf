#---------------------------------------------------------------------------------------#
# S3 bucket creation                    #
#---------------------------------------------------------------------------------------#



resource "aws_s3_bucket" "vpcflowlogbucket" {
  bucket = "aws-logs-299091871285-eu-central-1"

  tags = {
    Name        = "aws-logs-299091871285-eu-central-1"
    Environment = "Lab"
  }
  lifecycle {
    prevent_destroy = false

  }
}
# S3 bucket  Versioning enabled

resource "aws_s3_bucket_versioning" "version-flowlog-bucket" {
  bucket = aws_s3_bucket.vpcflowlogbucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


# Sever side encryption for s3 bucket
resource "aws_kms_key" "myvpcflowlogkey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

# Block S3 public access
resource "aws_s3_bucket_public_access_block" "block" {
  bucket              = aws_s3_bucket.vpcflowlogbucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_server_side_encryption_configuration" "example1" {
  bucket = aws_s3_bucket.vpcflowlogbucket.id

  rule {
    apply_server_side_encryption_by_default {
      #kms_master_key_id = aws_kms_key.myvpcflowlogkey.arn
      sse_algorithm = "AES256"
    }
  }
}

# resource "aws_s3_bucket_policy" "allow_access_to_store_vpclogs" {
#   bucket = aws_s3_bucket.vpcflowlogbucket.id
#   policy = data.aws_iam_policy_document.assume_role.json
# }

resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_s3_bucket.vpcflowlogbucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.vpc.vpc_id
  max_aggregation_interval = "60"
  destination_options {
    file_format        = "plain-text"
    per_hour_partition = true
    
  }
  tags = {
    Name = "Vpc-flow-logs"
  }
}


### IAM role to enable flow logs
# resource "aws_cloudwatch_log_group" "example" {
#   name = "example"
# }

resource "aws_s3_bucket_policy" "allow_vpc"{
  bucket = aws_s3_bucket.vpcflowlogbucket.id
  policy = data.aws_iam_policy_document.allow_vpc.json
  
}
resource "aws_s3_bucket_policy" "s3_bucket_lb_write" {
  bucket = aws_s3_bucket.vpcflowlogbucket.id 
  policy =data.aws_iam_policy_document.s3_bucket_lb_write.json
}

data "aws_iam_policy_document" "allow_vpc" {
  statement {
    sid = "AWSLogDeliveryWrite"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::aws-logs-299091871285-eu-central-1",
      "arn:aws:s3:::aws-logs-299091871285-eu-central-1/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        "299091871285"
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:logs:*:299091871285:*"
      ]
    }
  }
  statement {
    sid = "AWSLogDeliveryCheck"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::aws-logs-299091871285-eu-central-1",
      "arn:aws:s3:::aws-logs-299091871285-eu-central-1/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        "arn:aws:logs:*:299091871285:*"
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:logs:*:299091871285:*"
      ]
    }
  }
}
data "aws_iam_policy_document" "s3_bucket_lb_write" {
  policy_id = "s3_bucket_lb_write"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
        "arn:aws:s3:::aws-logs-299091871285-eu-central-1",
        "arn:aws:s3:::aws-logs-299091871285-eu-central-1/*"
    ]

    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "AWS"
    }
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect = "Allow"
    
    resources = [
      "arn:aws:s3:::aws-logs-299091871285-eu-central-1",
      "arn:aws:s3:::aws-logs-299091871285-eu-central-1/*"
    ]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }


  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::aws-logs-299091871285-eu-central-1",
      "arn:aws:s3:::aws-logs-299091871285-eu-central-1/*"
    ]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}















