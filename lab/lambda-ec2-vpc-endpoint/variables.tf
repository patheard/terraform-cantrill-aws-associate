variable "env" {
  description = "Name of the environment we're working in."
  type        = string
}

variable "lambda_functions" {
  description = "Names of the lambda functions that will be created.  There must be a matching <name>.py in the lab's functions directory."
  type        = set(string)
}
