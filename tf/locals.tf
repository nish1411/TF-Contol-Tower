locals {
  landing_zone_manifest = templatefile("${path.module}/manifest.json", {
    log_archive_account_id = aws_organizations_account.log_archive.id
    audit_account_id       = aws_organizations_account.audit.id
    kms_key_arn            = "arn:aws:kms:ap-southeast-1:021668988431:key/19436235-1eeb-4fa8-b84b-0d95dbe4d87e"
    region                 = "ap-southeast-1a"
  })
}
