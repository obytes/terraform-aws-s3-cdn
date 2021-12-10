## Generate Cloudfront Presigned URLs

1. Generate the key pairs using `generate_key_pairs.sh`

2. Create the cloudflare signer using this Terraform module.

3. Create a private S3 bucket and its Cloudfront Distribution and specify the key group created in step 2 as a trusted key group.
   
4. Upload the files you want to generate the presigned URL for them to the S3 bucket.

5. Generate the presigned url using:
    - The private key from step 1 
    - The cloudfront key id from step 2.
    - The bucket name from step 3.
    - The target filename from step 4

This is an example using a python script:

```python
import rsa
from datetime import datetime, timedelta
from botocore.signers import CloudFrontSigner

CLOUDFRONT_PUBLIC_KEY_ID = "Cloudfront public key ID"
PRIVATE_KEY = """
-----BEGIN RSA PRIVATE KEY-----
PRIVATE KEY: Store it in a safe place!
-----END RSA PRIVATE KEY-----
"""


def rsa_signer(message):
   """
   RSA Signer Factory
   :param message: Message to be signed using CloudFront Private Key
   :return: Signed message
   """
   return rsa.sign(
      message,
      rsa.PrivateKey.load_pkcs1(PRIVATE_KEY.encode("utf8")),
      "SHA-1",
   )


def generate_cloudfront_presigned_url(
        file_name: str,
        bucket_name: str,
        expires_in: int
):
   """
   Generate a CloudFront pre-signed URL using a canned policy
   :param file_name: Full path of the file inside the bucket
   :param bucket_name: bucket name
   :param expires_in: How many seconds the pre-signed url will be valid
   :return: Cloudfront pre-signed URL
   """
   url = f"https://{bucket_name}/{file_name}"
   expire_date = datetime.utcnow() + timedelta(seconds=expires_in)
   cf_signer = CloudFrontSigner(CLOUDFRONT_PUBLIC_KEY_ID, rsa_signer)
   return cf_signer.generate_presigned_url(url, date_less_than=expire_date)


print(generate_cloudfront_presigned_url(
   "this_is_a_private_file.png",
   "demo-private-media.kodhive.com",
   300
))
```
