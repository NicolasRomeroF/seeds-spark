
# Especificacion del proveedor
provider "google" {
 credentials = "${file("CREDENTIALS_FILE.json")}"
 project     = "seedsml"
 region      = "us-west1"
}

#Crear una nueva instancia
resource "google_compute_instance" "default" {
 name         = "seedsml"
 machine_type = "n1-standard-1"
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

resource "google_dataproc_cluster" "Cluster1" {
    name       = "Cluster1"
    region     = "us-central1"

    cluster_config {
        staging_bucket        = "ML in seeds"

        master_config {
            num_instances     = 1
            machine_type      = "n1-standard-1"
            disk_config {
                boot_disk_type = "pd-ssd"
                boot_disk_size_gb = 15
            }
        }

        worker_config {
            num_instances     = 2
            machine_type      = "n1-standard-1"
            disk_config {
                boot_disk_size_gb = 15
                num_local_ssds    = 1
            }
        }

        preemptible_worker_config {
            num_instances     = 0
        }

        # Override or set some custom properties
        software_config {
            image_version       = "1.3.7-deb9"
            override_properties = {
                "dataproc:dataproc.allow.zero.workers" = "true"
            }
        }

        gce_cluster_config {
            #network = "${google_compute_network.dataproc_network.name}"
            tags    = ["foo", "bar"]
        }

        # You can define multiple initialization_action blocks
        initialization_action {
            script      = "gs://dataproc-initialization-actions/stackdriver/stackdriver.sh"
            timeout_sec = 500
        }

    }
}