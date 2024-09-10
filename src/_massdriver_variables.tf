// Auto-generated variable declarations from massdriver.yaml
variable "apply_immediately" {
  type = bool
}
variable "aws_authentication" {
  type = object({
    data = object({
      arn         = string
      external_id = optional(string)
    })
    specs = object({
      aws = optional(object({
        region = optional(string)
      }))
    })
  })
}
variable "backup_retention_period" {
  type    = number
  default = 1
}
variable "deletion_protection" {
  type    = bool
  default = true
}
variable "enable_http_endpoint" {
  type    = bool
  default = false
}
variable "md_metadata" {
  type = object({
    default_tags = object({
      managed-by  = string
      md-manifest = string
      md-package  = string
      md-project  = string
      md-target   = string
    })
    deployment = object({
      id = string
    })
    name_prefix = string
    observability = object({
      alarm_webhook_url = string
    })
    package = object({
      created_at             = string
      deployment_enqueued_at = string
      previous_status        = string
      updated_at             = string
    })
    target = object({
      contact_email = string
    })
  })
}
variable "monitoring" {
  type = object({
    mode = optional(string)
    alarms = optional(object({
      database_capacity = optional(object({
        period    = number
        threshold = number
      }))
    }))
  })
  default = null
}
variable "mysql_version" {
  type = string
}
variable "scaling_configuration" {
  type = object({
    auto_pause               = bool
    max_capacity             = number
    min_capacity             = number
    seconds_until_auto_pause = number
    timeout_action           = string
  })
  default = null
}
variable "skip_final_snapshot" {
  type    = bool
  default = true
}
variable "source_snapshot" {
  type    = string
  default = null
}
variable "subnet_type" {
  type    = string
  default = "internal"
}
variable "username" {
  type = string
}
variable "vpc" {
  type = object({
    data = object({
      infrastructure = object({
        arn  = string
        cidr = string
        internal_subnets = list(object({
          arn = string
        }))
        private_subnets = list(object({
          arn = string
        }))
        public_subnets = list(object({
          arn = string
        }))
      })
    })
    specs = optional(object({
      aws = optional(object({
        region = optional(string)
      }))
    }))
  })
}
