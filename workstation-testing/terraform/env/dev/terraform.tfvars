instance_count        = 1

network_tags          = [
              "allow-int-dns","allow-int-http","allow-rdp","allow-dl-health-checks","egress-nat-gce",
              "windows","allow-winrm","allow-jenkins-deploy", "allow-ssh"]


service_account_email = "rqebuild-app-workstation-sa@clgx-rqebuild-app-dev-1898.iam.gserviceaccount.com"

zone                  = "us-west1-a"