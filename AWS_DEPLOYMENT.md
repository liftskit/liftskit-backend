# AWS Deployment Guide for Liftskit Backend

This guide shows how to deploy your Phoenix application to AWS using the most cost-effective solution.

## Cost Comparison

| Service | Fly.io (Current) | AWS Ultra-Cheap | AWS Standard | Savings |
|---------|------------------|-----------------|--------------|---------|
| **Compute** | ~$7.50/month (1GB shared) | $3.50/month (512MB, 0.25 vCPU) | $5/month (1GB, 1 vCPU) | $4-2.50/month |
| **Database** | ~$5-8/month | $0/month (Local PostgreSQL) | $3/month (RDS t4g.micro) | $5-8/month |
| **Storage** | ~$1-2/month | Included | Included | $1-2/month |
| **Bandwidth** | ~$1-3/month | 1TB included | 1TB included | $1-3/month |
| **Total** | **~$18/month** | **$3.50/month** | **$8/month** | **$14.50-9.50/month** |

## Why AWS Lightsail?

1. **Ultra Cost-Effective**: As low as $3.50/month (80% savings!)
2. **Better Performance**: Dedicated vCPU vs shared CPU
3. **More Control**: Full server access for custom configurations
4. **Flexible Database**: Choose local PostgreSQL ($0) or managed RDS ($3)
5. **Easy Scaling**: Upgrade to larger instances when needed

## Architecture Options

### Ultra-Cheap Option ($3.50/month)
```
Internet → Lightsail Nano (512MB RAM, 0.25 vCPU) → Local PostgreSQL
                ↓
            Nginx (Reverse Proxy)
                ↓
            Phoenix App (Docker)
```

### Standard Option ($8/month)
```
Internet → Lightsail Nano (512MB RAM, 0.25 vCPU) → RDS t4g.micro
                ↓
            Nginx (Reverse Proxy)
                ↓
            Phoenix App (Docker)
```

## Prerequisites

1. **AWS Account**: Sign up at [aws.amazon.com](https://aws.amazon.com)
2. **AWS CLI**: Install and configure with your credentials
3. **Terraform**: Install from [terraform.io](https://terraform.io)
4. **Docker**: For building your application image

## Current Deployment Status

**✅ DEPLOYED**: Your Liftskit Backend is currently running on AWS Lightsail!

- **Static IP**: `52.43.136.249`
- **Application URL**: http://52.43.136.249
- **Instance Type**: Lightsail Nano (512MB RAM, 0.25 vCPU)
- **Database**: Local PostgreSQL (no additional cost)
- **Monthly Cost**: $3.50
- **Status**: Active and running

## Quick Start

### 1. Configure Terraform

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:

```hcl
aws_region = "us-west-2"
app_name = "liftskit-backend"
phx_host = "your-domain.com"

# Database credentials
database_name = "liftskit_backend_prod"
database_username = "postgres"
database_password = "your-secure-database-password"

# Generate with: mix phx.gen.secret
secret_key_base = "your-secret-key-base-here"

# Your AWS Account ID (12 digits)
aws_account_id = "123456789012"
```

### 2. Deploy Infrastructure

```bash
chmod +x scripts/deploy-lightsail.sh
./scripts/deploy-lightsail.sh
```

### 3. Deploy Your Application

After the infrastructure is deployed, you'll get a static IP address. 

**Current Static IP**: `52.43.136.249`

Then:

```bash
# Build your Docker image
docker build -t liftskit-backend:latest .

# Save the image
docker save liftskit-backend:latest -o liftskit-backend.tar

# Upload to Lightsail
scp liftskit-backend.tar ubuntu@52.43.136.249:/opt/liftskit-backend/

# SSH into the instance
ssh ubuntu@52.43.136.249

# Load and run the image
cd /opt/liftskit-backend
docker load -i liftskit-backend.tar
./deploy.sh
```

## File Structure

```
terraform/
├── provider.tf          # AWS provider configuration
├── lightsail.tf         # Lightsail instance configuration
├── rds.tf              # RDS PostgreSQL database
├── vpc.tf              # VPC for RDS connectivity
├── ssm.tf              # Secrets management
├── variables.tf        # Input variables
├── outputs.tf          # Output values
├── user_data.sh        # Instance setup script
└── terraform.tfvars    # Your configuration (create from .example)

scripts/
├── deploy-lightsail.sh # Main deployment script
└── deploy.sh          # ECS deployment script (alternative)
```

## What Gets Created

### Lightsail Instance
- **Instance**: 1 vCPU, 1GB RAM, 40GB SSD ($5/month)
- **Static IP**: Reserved IP address
- **Security**: Configured ports (80, 443, 4000)
- **Software**: Docker, Nginx, AWS CLI pre-installed

### RDS Database
- **Instance**: db.t3.micro PostgreSQL 15.4 ($13/month)
- **Storage**: 20GB with auto-scaling up to 100GB
- **Backups**: 7-day retention
- **Security**: VPC-only access from Lightsail

### Security
- **SSM Parameters**: Encrypted secrets storage
- **IAM Roles**: Minimal permissions for Lightsail
- **Security Groups**: Restricted database access

## Monitoring and Maintenance

### View Logs
```bash
# SSH into your Lightsail instance
ssh ubuntu@52.43.136.249

# View application logs
docker-compose logs -f app

# View Nginx logs
sudo tail -f /var/log/nginx/access.log
```

### Update Application
```bash
# Build new image locally
docker build -t liftskit-backend:latest .

# Save and upload
docker save liftskit-backend:latest -o liftskit-backend.tar
scp liftskit-backend.tar ubuntu@52.43.136.249:/opt/liftskit-backend/

# SSH and deploy
ssh ubuntu@52.43.136.249
cd /opt/liftskit-backend
docker load -i liftskit-backend.tar
./deploy.sh
```

### Scale Up (if needed)
To upgrade to a larger Lightsail instance:
1. Go to AWS Lightsail console
2. Stop your instance
3. Change the bundle (e.g., to `micro_2_0` for 1 vCPU, 1GB RAM)
4. Start the instance

## Troubleshooting

### Application Not Starting
```bash
# Check if Docker is running
sudo systemctl status docker

# Check application logs
docker-compose logs app

# Check if database is accessible
docker-compose exec app mix ecto.migrate
```

### Database Connection Issues
```bash
# Check RDS endpoint
aws rds describe-db-instances --db-instance-identifier liftskit-backend-db

# Test connection from Lightsail
docker-compose exec app mix ecto.migrate
```

### SSL/HTTPS Setup
For production, set up SSL with Let's Encrypt:

```bash
# SSH into Lightsail instance
ssh ubuntu@52.43.136.249

# Install certbot (already done in user_data.sh)
sudo certbot --nginx -d your-domain.com

# Certbot will automatically configure Nginx
```

## Cost Optimization Tips

1. **Monitor Usage**: Use AWS Cost Explorer to track spending
2. **Right-size Database**: Start with db.t3.micro, upgrade if needed
3. **Reserved Instances**: Consider 1-year reserved instances for 30% savings
4. **Clean Up**: Remove unused resources to avoid charges

## Migration from Fly.io

1. **Export Data**: Use `pg_dump` to export your Fly.io database
2. **Deploy AWS**: Follow this guide to set up AWS infrastructure
3. **Import Data**: Import your data into the new RDS instance
4. **Update DNS**: Point your domain to the new Lightsail static IP
5. **Test**: Verify everything works before switching traffic
6. **Clean Up**: Delete your Fly.io resources

## Support

- **AWS Documentation**: [docs.aws.amazon.com/lightsail](https://docs.aws.amazon.com/lightsail)
- **Terraform AWS Provider**: [registry.terraform.io/providers/hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws)
- **Phoenix Deployment**: [hexdocs.pm/phoenix/deployment](https://hexdocs.pm/phoenix/deployment.html)
