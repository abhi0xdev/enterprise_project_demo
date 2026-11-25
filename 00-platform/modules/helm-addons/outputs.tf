output "releases" {
  value = { for name, r in helm_release.this : name => r.status }
}