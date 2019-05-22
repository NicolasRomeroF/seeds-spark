
# Especificacion del proveedor
provider "google" {
 credentials = "${file("CREDENTIALS_FILE.json")}"
 project     = "seedsml"
 region      = "us-west1"
}

#Crear una nueva instancia
resource "google_compute_instance" "default" {
 name         = "seedsML-R-Spark"
 machine_type = "n1-standard-4"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

# Hay que asegurarse de que flask esta installado
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

network_interface {
   network = "default"
}
}

