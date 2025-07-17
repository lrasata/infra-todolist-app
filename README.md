# Infra-todolist-app | Terraform project 🚧

> **Status**: 🚧 Under Construction

## Overview

This Terraform project manages the infrastructure for [Todolist-app : a full-stack application built with `MongoDB, Express, React and Node.js`](https://github.com/lrasata/todo-list-app) .  
It provisions resources such as **[AWS VPC, EC2, Route 53, etc.]**.

---

## Prerequisites

- Terraform >= 1.3 installed: https://www.terraform.io/downloads.html
- Access to AWS configured

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/lrasata/infra-todolist-app.git
cd infra-todolist-app
```

2. Initialize Terraform:

````bash
terraform init
````
3. Fromat configuration:

````bash
terraform fmt
````

4. Validate configuration:

````bash
terraform validate
````

4. Review changes:

````bash
terraform plan
````

5. Apply infrastructure:

````bash
terraform apply
````

## Important Files
- main.tf — main Terraform configuration
- variables.tf — input variables
- outputs.tf — output values
- .terraform.lock.hcl — provider dependency lock file

## Notes
- Always review the output of terraform plan before applying changes.
- Keep .terraform.lock.hcl committed for consistent provider versions.

## Destroying Infrastructure
To tear down all resources managed by this project:

````bash
terraform destroy
````