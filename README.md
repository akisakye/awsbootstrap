# AWS quick bootstrap
Terraform templates to bootstrap AWS VPC and EC2 resources

# Use
Use this as a quick starting point to build AWS infrastructure. Much easier than point and clicking on the AWS web console.

# Usage

Edit `variables.tf` to modify and change variables to reflect your environment.
Also edit variable `key_path` to reflect the location of your ssh public key that will be injected inside the instances.
The files `backendinstall.sh` and `frontinstall.sh` includes bootstrap config that the instances will run on first boot.

Finally,

```
terraform plan
````
and 

```
terraform apply
```

# What does this build

This will create a VPC with 2 subnets {Private and Public} and will create 2 instances attached to private and public networks. The instance attached on the public network will also get assigned a public IP address.

# Feedback
kisakye [at[ gmail.com
