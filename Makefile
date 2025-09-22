AWS_PROFILE ?= default
ENV ?= dev
TF_DIR := envs/$(ENV)

init:
	cd $(TF_DIR) && terraform init -backend-config=backend.hcl
plan:
	cd $(TF_DIR) && terraform plan -out=tfplan
apply:
	cd $(TF_DIR) && terraform apply -auto-approve tfplan
destroy:
	cd $(TF_DIR) && terraform destroy

ansible:
	./scripts/export_tf_outputs.sh $(ENV)
	ansible-playbook -i ansible/inventories/$(ENV)/aws_ec2.yml ansible/playbooks/site.yml
