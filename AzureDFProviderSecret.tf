#################################################################
# Variables for Azure Registration
#################################################################
variable "AzureSubscriptionID" {
  type    = "string"
  default = "f1f020d0-0fa6-4d01-b816-5ec60497e851"
}

variable "AzureClientID" {
  type    = "string"
  default = "7d161630-069a-4410-8989-a9c34ce454f7"
}

variable "AzureClientSecret" {
  type    = "string"
  default = "fEJFCwK/kGnBnV+Q2ZgkSh5nqdEQoGy/k9Ep66TxZHA="
}

variable "AzureTenantID" {
  type    = "string"
  default = "5beba21b-eaa1-4969-abbd-c3b6c2a226bf"
}



# Variable defining VM Admin Name

variable "VMAdminName" {

    type    = "string"
    default = "vmadmin"
}

# Variable defining VM Admin password

variable "VMAdminPassword" {

    type    = "string"
    default = "Devoteam75!"
}

# Variable defining SSH Key
variable "AzurePublicSSHKey" {
  type    = "string"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjtwUDd3ybe7Sq9MRNkw2DMQjcNfTEnswiyyvPGRng6ijnpHWQ1SoQYsfF9LDrTK5WqM3MwGSjYvTJVg9FD60y/0zM1aJ+bNKwBePYkchIgLII1PjlTsafRPpZZ/3EYYvlCSfR/yNSnuZyH8oii0NKYrUYYFh4cQtNQCcydnVhcsJq6glnE+kbr2TAXL2xEoHw9KZmLzPDCFQyEc6wpHPYOEaCenfQylhf0+nMqauhwoEtjvvImqZSaSNSGvT2xTCZJ6UPgh27YOhB0iiVJT7jyEdvYEEfMcyD/vN9YESSMCJnDInEGfc49Vj9mvCCkbbl3QqNJbaegXqUc+Y1Nneww== rsa-key-20170707"
}
