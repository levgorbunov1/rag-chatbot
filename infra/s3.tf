# CUR Reports

module "cur_v2_hourly" {
  #checkov:skip=CKV_TF_1:Module registry does not support commit hashes for versions

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.3.0"

  bucket = "coat-${local.environment}-cur-v2-hourly"

  force_destroy = true

  attach_deny_insecure_transport_policy = true
  attach_policy                         = true

  policy =  data.aws_iam_policy_document.coat_cur_v2_hourly_bucket_policy.json

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.cur_s3_kms.key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning = {
    status = "Enabled"
  }

  lifecycle_rule = [
    {
      id      = "DeleteOldVersions"
      enabled = true
      noncurrent_version_expiration = {
        days = 1
      }
    }
  ]
}

data "aws_iam_policy_document" "coat_cur_v2_hourly_bucket_policy" {
  statement {
    sid    = "S3PutObject"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::coat-${local.environment}-cur-v2-hourly/*",
      "arn:aws:s3:::coat-${local.environment}-cur-v2-hourly"
    ]
    principals {
      type        = "Service"
      identifiers = ["bcm-data-exports.amazonaws.com"]
    }
  }
  statement {
    sid    = "S3ListGetObject"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = ["arn:aws:s3:::coat-${local.environment}-cur-v2-hourly"]
    principals {
      type        = "Service"
      identifiers = ["bcm-data-exports.amazonaws.com"]
    }
  }
  statement {
    sid    = "AthenaAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload"
    ]
    resources = [
      "arn:aws:s3:::coat-${local.environment}-cur-v2-hourly/ctas/fct-daily-cost/*",
      "arn:aws:s3:::coat-${local.environment}-cur-v2-hourly",
      "arn:aws:s3:::coat-${local.environment}-cur-v2-hourly/*"
    ]
    principals {
      type = "Service"
      identifiers = [
        "athena.amazonaws.com",
        "glue.amazonaws.com"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
  statement {
    sid    = "RAGLambdaAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:::coat-${local.environment}-cur-v2-hourly",
      "arn:aws:s3:::coat-${local.environment}-cur-v2-hourly/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.rag_lambda_role.arn]
    }
  }
}