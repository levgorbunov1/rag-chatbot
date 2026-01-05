module "cur_s3_kms" {
  #checkov:skip=CKV_TF_1:Module registry does not support commit hashes for versions
  #checkov:skip=CKV_TF_2:Module registry does not support tags for versions

  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.1"

  aliases                 = ["s3/cur"]
  description             = "S3 CUR KMS key"
  enable_default_policy   = true
  deletion_window_in_days = 7

  key_statements = [,
    {
      sid = "AllowGlueService"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]
      effect    = "Allow"
      principals = [
        {
          type        = "Service"
          identifiers = ["glue.amazonaws.com"]
        }
      ]
    },
    {
    sid    = "RAGLambdaAccess"
    effect = "Allow"
    actions = [
      "kms:Decrypt*"
    ]
    resources = ["*"]
    principals = [
      {
        type        = "AWS"
        identifiers = [aws_iam_role.rag_lambda_role.arn]
      }
    ]
   }
  ]

  tags = local.tags
}