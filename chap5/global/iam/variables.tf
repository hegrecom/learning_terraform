variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

variable "user_names_for_each" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["teo", "brinity", "phormeus"]
}

variable "hero_thousand_faces" {
  description = "map"
  type        = map(string)
  default = {
    "neo"      = "hero"
    "trinity"  = "love interest"
    "morpheus" = "mentor"
  }
}

variable "give_neo_cloudwatch_full_access" {
  description = "Give neo cloudwatch full access"
  type        = bool
  default     = false
}
