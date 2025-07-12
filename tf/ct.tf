#data "template_file" "controltower_manifest" {
#  template = file("${path.module}/manifest.json")
#  vars = {
#    log_archive_account_id = aws_organizations_account.log_archive.id
#    audit_account_id       = aws_organizations_account.audit.id
#  }
#}
#
#resource "aws_controltower_landing_zone" "example" {
#  manifest_json = data.template_file.controltower_manifest.rendered
#  version       = "3.3"
#}