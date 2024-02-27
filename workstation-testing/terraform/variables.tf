/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



variable "ip_names" {
  description = "List of ip names to provision for databases in  region"
  type        = list(string)
  default     = []
}


variable "ip_type" {
  description = "IP address type. One of 'INTERNAL' or 'EXTERNAL'."
  type        = string
  default     = "INTERNAL"
}

variable "subnetwork_project" {
  description = "The project the subnetwork is hosted in (for shared vpc support)"
  default     = ""
}

variable "subnetworks" {
  description = "List of GCP subnets in  region from which to reserve IPs. List wraps around if shorter than list of names."
  type        = list(string)
}


variable "project_id" {
  description = "The project ID to host the cluster in"
  default = "clgx-clareity-glb-stg-8143"
}



variable "application" {
  type = string
  default = ""
}

variable "purpose" {
  type = string
}

variable "organization" {
  type = string
}

variable "primary_company_code" {
  type        = string
  description = "Primary CompanyCode: numeric, 4 digits"
}

variable "primary_cost_center" {
  type        = string
  description = "Primary CostCenter: numeric, 6 digits"
}

variable "chargeback_company_code" {
  type        = string
  description = "Chargeback CompanyCode: numeric, 4 digits"
}

variable "chargeback_cost_center" {
  type        = string
  description = "Chargeback CostCenter: numeric, 6 digits"
}

variable "case_wise_appid" {
  type        = string
  description = "CasewiseAppID: numeric, 10 digits"
}

variable "financial_owner" {
  type        = string
  description = "Financial Owner Email: Since GCP does not allow '@', don't include '@corelogic.com'. All email addresses are assumed to be '@corelogic.com'"
}

variable "tech_lead" {
  type        = string
  description = "Technical Lead Email: Since GCP does not allow '@', don't include '@corelogic.com'. All email addresses are assumed to be '@corelogic.com'"
}

variable "resolver_group" {
  type        = string
  description = "Support Owner/Group Email: Since GCP does not allow '@', don't include '@corelogic.com'. All email addresses are assumed to be '@corelogic.com'"
}

# Optional for projects/accounts. Mandatory for resources
variable "tier" {
  type        = string
  description = "Tier: ie Web, App, or Data"
}

variable "backup" {
  type        = string
  description = "A value indicating whether the labeled resource should be included in the backup strategy."
}

variable "technology" {
  type        = string
  description = "A value indicating the tool/language that is running. Example: Sql/PostgreSQL."
}


variable "ad_group" {
  description = "See description in repository: corelogic/terraform-null-label"
  type        = string
}

variable "vault_token" {
  type = string
  default = ""
}

variable "vault_addr" {
  type = string
  default = ""
}

variable "vault_secret_path" {
  type    = string
  default = ""
}

variable "network_ip_reserve" {
  description = "Whether to reserve an internal static ip. Only set to false if you are using an existing static ip."
  default     = false
}

variable "environment" {
  type        = string
  description = "Environment: ie Dev, DR, Prod, QA, SA, SB, Test, UAT, Staging, Training, Sandbox, Other"
}

variable "region" {
  description = "GCP region name"
  type        = string
}

variable "subnetwork" {
  description = "Name of subnetwork"
  type        = string
}


variable "network" {
  description = "The VPC network to host the instances in"
}

variable "machine_type" {
  description = "Instance machine type"
  default     = "n1-standard-1"
}

variable "min_cpu_platform" {
  description = "Specifies a minimum CPU platform for the VM instance. Applicable values are 'Intel Haswell' or 'Intel Skylake'"
  default     = "Intel Cascade Lake"
}


variable "boot_disk_auto_delete" {
  description = "Whether the disk will be auto-deleted when the instance is deleted. Defaults to true."
  default     = true
}

variable "boot_disk_type" {
  description = "The GCE disk type. May be set to pd-standard or pd-ssd"
  default     = "pd-ssd"
}

variable "boot_disk_size" {
  description = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image"
}

variable "network_tags" {
  type        = list
  description = "List of tags to apply to the resource"
  default     = []
}

variable "metadata_startup_script" {
  type        = string
  description = " An alternative to using the startup-script metadata key, except this one forces the instance to be recreated (thus re-running the script) if it is changed. This replaces the startup-script metadata key on the created instance and thus the two mechanisms are not allowed to be used simultaneously."
  default     = ""
}

variable "byte_length" {
  description = "The number of random bytes to produce. The minimum value is 1, which produces eight bits of randomness."
  default     = 1
}

variable "use_random_id" {
  description = "A value indicating whether to append a random id to the end of the instance name. If the instance_count > 1, a random_id will be appended regardless of this value."
  default     = true
}

variable "network_ip" {
  description = "Internal static ip to assign instance. Only applies when not using instance group."
  type        = list
  default     = []
}

variable "service_account_email" {
  description = "Service account for the instances"
}

variable "ip_protocol" {
  description = "The IP protocol to which this rule applies. Valid options are TCP, UDP, ESP, AH, SCTP or ICMP. When the load balancing scheme is INTERNAL, only TCP and UDP are valid: https://www.terraform.io/docs/providers/google/r/compute_forwarding_rule.html#ip_protocol"
  default     = "TCP"
}

variable "service_account_scopes" {
  type        = list
  description = "Service account scopes"
  default     = ["cloud-platform"]
}

variable "boot_image_project" {
  type = string
  default = "clgx-imgfact-repo-glb-prd-f2a0"
}

variable "boot_image_family" {
  description = "The image from which to initialize this disk."
  default = "cl-windows-2016"
}

variable "instance_name" {
  description = "Name of GCP instance"
  type        = string
}

variable "zone" {
  description = "GCP zone name"
  type        = string
}

variable "data_disk_size" {
  description = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image"
}

variable "ip_address" {
  description = "IP address for reserved balancer"
  type        = string
  default     = ""
}

variable "instance_count" {
  description = "The target number of instances for each zone."
  default     = 1
}