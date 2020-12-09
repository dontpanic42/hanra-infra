terraform {
  backend "s3" {
    bucket = "hanra.bytelike.de-state"
    key    = "hanra.bytelike.de.state"
    region = "eu-central-1"
  }

  required_providers {
  }
}