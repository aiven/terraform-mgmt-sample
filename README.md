# Managing your Aiven infrastructure with Terraform
This code sample sets up an open source data infrastructure on the Aiven platform using Terraform, consisting of a PostgreSQL instance sending metrics to InfluxDB, which can be visualized with Grafana.

Read more about this setup on the [Managing your Aiven infrastructure with Terraform]() article.

For more information, check the [Aiven Terraform Provider](https://aiven.github.io/terraform-provider-aiven/README) official documentation.

## Prerequisites
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli), at least v0.13
- [Aiven account](https://console.aiven.io/signup)

## Running it
Populate the `terraform.tfvars` file with your Aiven access token and project name.

To create the infrastructure, run the following commands:
```bash
$ terraform plan
$ terraform apply
```

## Connecting to PostgreSQL
To connect to the deployed PostgreSQL instance, run the following command:
```bash
$ psql "$(terraform output -raw postgresql_service_uri)"
```

## Visualizing metrics with Grafana
Run the following command to find the Grafana URL, username and password:
```bash
$ terraform output -raw grafana_service_uri
$ terraform output -raw grafana_service_username
$ terraform output -raw grafana_service_password
```

Open the Grafana URL in your web browser with the outputted username and password.

## Clean up
To destroy the infrastructure, set the `termination_protection` flag under the PostgreSQL resource to `false` and run the command below:
```
$ terraform destroy
```

# License
This project is licensed under the [Apache License, Version 2.0](https://github.com/aiven/aiven-kafka-connect-s3/blob/master/LICENSE).