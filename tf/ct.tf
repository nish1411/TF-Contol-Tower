resource "aws_controltower_landing_zone" "example" {
  manifest_json = file("${path.module}/manifest.json")
  version       = "3.3"
}