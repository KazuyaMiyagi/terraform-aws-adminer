AWS adminer Terraform module
====================================================================================================

Terraform module which deploys Adminer official Container to Amazon ECS

Usage
----------------------------------------------------------------------------------------------------

```hcl
module "adminer" {
  source                   = "KazuyaMiyagi/adminer/aws"
  aws_region               = data.aws_region.current.name
  platform_version         = "LATEST"
  cluster_name             = "adminer-cluster"
  service_name             = "adminer-service"
  task_family_name         = "adminer-taskdef"
  image                    = "adminer:standalone"
  cpu                      = "256"
  memory                   = "512"
  desired_count            = 1
  autoscaling_settings     = {
    scale-in : {
      name         = "adminer_cluster_adminer_service_scale_in"
      schedule     = "cron(0 12 ? * * *)"
      max_capacity = 0
      min_capacity = 0
    },
    scale-out : {
      name         = "adminer_cluster_adminer_service_scale_out"
      schedule     = "cron(0 0 ? * MON-FRI *)"
      max_capacity = 2
      min_capacity = 1
    }
  }
  adminer_subnets          = [aws_subnet.private_0.id, aws_subnet.private_1.id]
  adminer_security_groups  = [aws_security_group.lb.id]
  adminer_target_group_arn = aws_lb_target_group.adminer.arn
  adminer_log_group_name   = "/ecs/adminer"
}
```

Examples
----------------------------------------------------------------------------------------------------

* [Simple](https://github.com/KazuyaMiyagi/terraform-aws-adminer/tree/master/examples/simple)

Requirements
----------------------------------------------------------------------------------------------------

| Name      | Version    |
|-----------|------------|
| terraform | >= 0.12.\* |
| aws       | >= 3.12.\* |

Providers
----------------------------------------------------------------------------------------------------

| Name | Version    |
|------|------------|
| aws  | >= 3.12.\* |

Inputs
----------------------------------------------------------------------------------------------------

| Name                        | Description                                    | Type           | Default                     | Required |
|-----------------------------|------------------------------------------------|----------------|-----------------------------|:--------:|
| aws\_region                 | AWS Region                                     | `string`       | `""`                        | yes      |
| platform\_version           | ECS Service platform version                   | `string`       | `"1.4.0"`                   | no       |
| cluster\_name               | The name of ecs cluster                        | `string`       | `"adminer-cluster"`         | no       |
| service\_name               | The name of ecs service                        | `string`       | `"adminer-service" `        | no       |
| task\_family\_name          | The name of ecs task definition                | `string`       | `"adminer-taskdef"  `       | no       |
| image                       | Container image and tag                        | `string`       | `"adminer:standalone"`      | no       |
| cpu                         | Container cpu units                            | `string`       | `"256"`                     | no       |
| memory                      | Container memory size                          | `string`       | `"512"`                     | no       |
| desired\_count              | Adminer container count                        | `number`       | `0`                         | no       |
| autoscaling\_settings       | Autoscaling settings                           | `map(object)`  | `{}`                        | no       |
| adminer\_subnets            | Subnet ID list to be attached to the adminer   | `list(string)` | `[]`                        | yes      |
| adminer\_security\_groups   | Security group list to be attached the adminer | `list(string)` | `[]`                        | yes      |
| adminer\_target\_group\_arn | Target group to be attached the adminer        | `string`       | `""`                        | yes      |
| adminer\_log\_group\_name   | adminer log group name                         | `string`       | `"/ecs/adminer"`            | no       |

Outputs
----------------------------------------------------------------------------------------------------

No output.

License
----------------------------------------------------------------------------------------------------

Apache 2 Licensed. See LICENSE for full details.
