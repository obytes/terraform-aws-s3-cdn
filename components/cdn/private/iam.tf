###############################################
#            Only Allow Cloudfront            |
#  Cloudfront dist can list and view content  |
###############################################
data "aws_iam_policy_document" "_" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket._.arn,
      "${aws_s3_bucket._.arn}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity._.iam_arn,
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "_" {
  bucket = aws_s3_bucket._.id
  policy = data.aws_iam_policy_document._.json
}
