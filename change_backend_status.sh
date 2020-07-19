#!/bin/bash

backend_status=`cat backend_status | awk '/s3_backend_configured/{print $2}'`
if [ "$backend_status" == false ]
then
	terraform init
	terraform apply -auto-approve -target=aws_s3_bucket.prod_terraform_state -target=aws_dynamodb_table.prod_terraform_locks
	sed -i "/s3_backend_configured/s/false/true/" backend_status
	backend_data='''terraform {
    backend "s3"  {
        bucket = "nishant-terraform-state-bucket-testenv"
		key    = "global/s3/terraform.tfstate"
        region = "ap-south-1"
    }
}
	'''
	echo -e "$backend_data" | cat - main.tf > temp && mv temp main.tf
	echo ".terraform/*" > .gitignore
	echo "terraform.*" >> .gitignore
	git add .
	git commit -m "upload"
	git push origin prod_master

fi