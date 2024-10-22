# --- Root/variables.tf ---

variable "aws_region" {
  # default = "eu-west-2"
}

variable "access_ip" {
  type = string
}

# --- database variables ---

variable "dbname" {
  type = string

}

variable "dbuser" {
  type      = string
  sensitive = true
}

variable "dbpassword" {
  type      = string
  sensitive = true
}
