output "public_ip" {
  description = "Elastic IP for the crAPI lab. Create a Cloudflare A record for var.domain_name pointing here."
  value       = aws_eip.crapi.public_ip
}

output "crapi_url" {
  description = "Expected public URL after Cloudflare DNS points at public_ip."
  value       = "http://${var.domain_name}"
}

output "ssh_disabled_by_default" {
  description = "SSH is closed unless allowed_ssh_cidr is set. Prefer SSM Session Manager."
  value       = var.allowed_ssh_cidr == ""
}

output "ssm_start_session_command" {
  description = "Use this when the instance appears in SSM Managed Instances."
  value       = "aws ssm start-session --target ${aws_instance.crapi.id} --region ${var.region}"
}

output "cloudflare_dns_instruction" {
  description = "Manual DNS step."
  value       = "Create A ${var.domain_name} -> ${aws_eip.crapi.public_ip} in Cloudflare."
}
