variable "region" {
  description = "AWS region for the crAPI lab."
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Name prefix for crAPI lab resources."
  type        = string
  default     = "navien-crapi"
}

variable "domain_name" {
  description = "Public hostname expected in Cloudflare. Terraform does not manage DNS."
  type        = string
  default     = "vuln.navien.ai"
}

variable "instance_type" {
  description = "Cheap x86 instance for Docker Compose. t3.small is intentionally modest; bump to t3.medium if crAPI OOMs."
  type        = string
  default     = "t3.small"
}

variable "root_volume_gb" {
  description = "Root volume size in GiB."
  type        = number
  default     = 30
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH. Empty disables SSH ingress; prefer SSM if possible."
  type        = string
  default     = ""
}

variable "crapi_repo_url" {
  description = "Git repository used on the EC2 instance. It must be publicly cloneable unless a deploy credential is added."
  type        = string
  default     = "https://github.com/navien-repo/crAPI.git"
}

variable "crapi_repo_ref" {
  description = "Branch or tag to deploy from crapi_repo_url."
  type        = string
  default     = "develop"
}

variable "crapi_version" {
  description = "crAPI Docker image tag for official services. The web image is rebuilt locally from crapi_repo_ref using this tag."
  type        = string
  default     = "latest"
}

variable "reset_interval_minutes" {
  description = "How often to reset crAPI containers and volumes. 120 keeps the lab clean every 2h."
  type        = number
  default     = 120
}
