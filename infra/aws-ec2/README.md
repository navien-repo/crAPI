# crAPI AWS EC2 lab

Terraform for a disposable OWASP crAPI lab at `vuln.navien.ai`.

This stack is intentionally separate from NaviHAL. It creates a small EC2
instance, installs Docker Compose, runs the crAPI compose file and resets the
lab every two hours by default. Official images are used for the backend
services; `crapi-web` is rebuilt locally from `crapi_repo_url` /
`crapi_repo_ref` so local UI customizations are deployed.

## Deploy

```bash
cd infra/aws-ec2
terraform init
terraform plan -out=tf.plan
terraform apply tf.plan
```

After apply, create this Cloudflare DNS record:

```text
A vuln.navien.ai -> $(terraform output -raw public_ip)
```

## Operations

SSH is disabled by default. Use SSM Session Manager:

```bash
terraform output -raw ssm_start_session_command
```

Useful commands on the instance:

```bash
sudo systemctl status crapi-reset.timer
sudo systemctl start crapi-reset.service
sudo docker compose -f /opt/crapi/deploy/docker/docker-compose.yml ps
sudo docker compose -f /opt/crapi/deploy/docker/docker-compose.yml logs --tail=200
```

The reset job runs:

```bash
git fetch/reset crapi_repo_ref
docker compose down -v --remove-orphans
docker compose pull --ignore-buildable
docker compose build crapi-web
docker compose up -d
```

## Notes

- Data is ephemeral by design.
- `t3.small` is cheap and may be tight. The instance adds a 2 GiB swapfile for
  the local web build; use `t3.medium` if the lab still OOMs.
- Only HTTP port 80 is public. The compose services bind to localhost.
- `crapi_repo_url` must be publicly cloneable unless a deploy credential is
  added to the instance.
