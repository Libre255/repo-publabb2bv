variable "sql-servername" {
    description = "Please Enter MS Server Username"
    type = string
    sensitive = false  
}

variable "sql-password" {
    description = "Please Enter MS Server admin pass (sensitve data -- u will NOT see it)"
    type = string
    sensitive = true  
}

variable "sql-ip-adress" {
    description = "PLease Enter start IP address for your connection"
    type = string
    sensitive = false
  
}

variable "sql-ip-endadress" {
    description = "PLease Enter end IP address for your connection"
    type = string
    sensitive = false
  
}