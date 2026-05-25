provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "crapi-vulnerable-lab"
      Environment = "lab"
      ManagedBy   = "terraform"
    }
  }
}
