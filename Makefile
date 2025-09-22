AWS_PROFILE ?= default
ENV ?= dev
TF_DIR := envs/$(ENV)

.PHONY: init plan apply destroy refresh ansible outputs fmt lint

init:
	cd $(TF_DIR) && terraform init -backend-config=backend.hcl

plan: fmt
	cd $(TF_DIR) && terraform plan -out=tfplan

apply:
	cd $(TF_DIR) && terraform apply -auto-approve tfplan

destroy:
	cd $(TF_DIR) && terraform destroy

refresh:
	cd $(TF_DIR) && terraform refresh

outputs:
	cd $(TF_DIR) && terraform output

ansible:
	./scripts/export_tf_outputs.sh $(ENV)
	ansible-playbook -i ansible/inventories/$(ENV)/aws_ec2.yml ansible/playbooks/site.yml

fmt:
	terraform fmt -recursive
	yamllint -s . || true
	ansible-lint || true

lint:
	tflint --recursive || true
