AWS adminer Terraform module
====================================================================================================

Terraform module which deploys Adminer official Container to Amazon ECS

Usage
----------------------------------------------------------------------------------------------------

```hcl
module "adminer" {
  source                    = "KazuyaMiyagi/adminer/aws"
  aws_region                = data.aws_region.current.name
  image                     = "adminer:standalone"
  desired_count             = 1
  adminer_subnets           = [aws_subnet.private_0.id, aws_subnet.private_1.id]
  adminer_security_groups   = [aws_security_group.lb.id]
  adminer_target_group_arn  = aws_lb_target_group.adminer.arn
  adminer_log_group_name    = "/ecs/adminer"
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

| Name                        | Description                                    | Type           | Default                | Required |
|-----------------------------|------------------------------------------------|----------------|------------------------|:--------:|
| aws\_region                 | AWS Region                                     | `string`       | `""`                   | yes      |
| image                       | Container image and tag                        | `string`       | `"adminer:standalone"` | no       |
| desired\_count              | Adminer container count                        | `number`       | `0`                    | no       |
| adminer\_subnets            | Subnet ID list to be attached to the adminer   | `list(string)` | `[]`                   | yes      |
| adminer\_security\_groups   | Security group list to be attached the adminer | `list(string)` | `[]`                   | yes      |
| adminer\_target\_group\_arn | Target group to be attached the adminer        | `string`       | `""`                   | yes      |
| adminer\_log\_group\_name   | adminer log group name                         | `string`       | `"/ecs/adminer"`       | no       |

Outputs
----------------------------------------------------------------------------------------------------

No output.

License
----------------------------------------------------------------------------------------------------

Apache 2 Licensed. See LICENSE for full details.
