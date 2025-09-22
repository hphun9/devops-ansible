```bash
./
├── .github/
│   └── workflows/
│       ├── terraform-ci.yml          # fmt/validate/plan & tflint
│       └── ansible-ci.yml            # ansible-lint + yamllint
├── .pre-commit-config.yaml           # fmt, lint, trailing-whitespace, tflint, yamllint
├── .gitignore
├── LICENSE
├── Makefile                          # init/plan/apply/ansible
├── README.md                         
├── docs/
│   ├── architecture.md               
│   ├── runbook.md                   
│   └── diagrams/
│       └── ha-wordpress.drawio
├── envs/                             
│   ├── dev/
│   │   ├── backend.hcl               # S3/DynamoDB remote state (dev)
│   │   ├── main.tf                  
│   │   ├── providers.tf
│   │   ├── terraform.tfvars          # variables for specific environment
│   │   └── variables.tf
│   ├── stage/
│   │   ├── backend.hcl
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── prod/
│       ├── backend.hcl
│       ├── main.tf
│       ├── providers.tf
│       ├── terraform.tfvars
│       └── variables.tf
├── modules/                          # Terraform reusable modules
│   ├── vpc/
│   │   ├── main.tf                   # VPC, IGW, NAT, 2+AZ subnets
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/
│   │   ├── main.tf                   # Security Groups: ALB, EC2, RDS, EFS
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── alb/
│   │   ├── main.tf                   # ALB + target group + listeners + health checks
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── asg_ec2/
│   │   ├── main.tf                   # Launch template + AutoScaling (min>=2)
│   │   ├── user_data.sh              # cloud-init to install Ansible deps/SSM
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── rds/
│   │   ├── main.tf                   # MySQL/Aurora, Multi-AZ, params
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── efs/
│   │   ├── main.tf                   # EFS + mount targets (share wp-content)
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ssm/
│       ├── main.tf                   # SSM parameters (DB creds, salts…)
│       ├── variables.tf
│       └── outputs.tf
├── ansible/
│   ├── inventories/
│   │   ├── dev/
│   │   │   ├── aws_ec2.yml           # Dynamic inventory plugin
│   │   │   └── group_vars/
│   │   │       └── all.yml           # WP, DB endpoint (get from Terraform outputs)
│   │   ├── stage/
│   │   │   ├── aws_ec2.yml
│   │   │   └── group_vars/all.yml
│   │   └── prod/
│   │       ├── aws_ec2.yml
│   │       └── group_vars/all.yml
│   ├── roles/
│   │   ├── common/                   # timezone, packages, fail2ban, cloudwatch/ssm
│   │   │   ├── tasks/main.yml
│   │   │   └── handlers/main.yml
│   │   ├── nginx-php/                # Nginx + PHP-FPM
│   │   │   ├── tasks/main.yml
│   │   │   ├── templates/*.j2
│   │   │   └── handlers/main.yml
│   │   ├── efs-mount/                # mount EFS -> /var/www/html/wp-content
│   │   │   └── tasks/main.yml
│   │   └── wordpress/
│   │       ├── tasks/main.yml        # download WP, create wp-config.php, perms
│   │       ├── templates/wp-config.php.j2
│   │       └── files/                # (optional) mu-plugins, healthcheck.php
│   ├── playbooks/
│   │   └── site.yml                  # include common, nginx-php, efs-mount, wordpress
│   ├── requirements.yml              # Galaxy roles/collections
│   └── ansible.cfg
├── scripts/
│   ├── export_tf_outputs.sh          # outputs -> ansible group_vars
│   ├── ssh_bastion.sh                # ssh through bastion
│   └── health_check.sh
└── packer/                           # (optional) Golden AMI
    ├── wordpress.json
    └── http/user_data.sh

```