# crAPI AWS EC2 lab

Terraform for a disposable OWASP crAPI lab at `vuln.navien.ai`.

This stack is intentionally separate from NaviHAL. It creates a small EC2
instance, installs Docker Compose, runs the official crAPI compose file and
resets the lab every two hours by default.

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
docker compose down -v --remove-orphans
docker compose pull
docker compose up -d
```

## Notes

- Data is ephemeral by design.
- `t3.small` is cheap and may be tight. Use `t3.medium` if the lab OOMs.
- Only HTTP port 80 is public. The compose services bind to localhost.
