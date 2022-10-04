variable "fail_SNYK-CC-GCP-282" {
  type    = bool
  default = false
}

variable "fail_SNYK-CC-TF-32" {
  type    = bool
  default = false

}

variable "project" {
  type    = string
  default = "snyk-csg"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}
