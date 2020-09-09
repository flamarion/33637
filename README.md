1. Preparation
* Create the workdir 
```
mkdir worker_image
WORKDIR=$(realpath worker_image)
cd $WORKDIR
```
* Repeat this step for all other providers
```
mkdir -p terraform.d/plugins
cd terraform.d/plugins
wget https://releases.hashicorp.com/terraform-provider-aws/3.5.0/terraform-provider-aws_3.5.0_linux_amd64.zip -O terraform-provider-aws_3.5.0_linux_amd64.zip
wget https://releases.hashicorp.com/terraform-provider-vault/2.13.0/terraform-provider-vault_2.13.0_linux_amd64.zip -O terraform-provider-vault_2.13.0_linux_amd64.zip
unzip terraform-provider-aws_3.5.0_linux_amd64.zip
unzip terraform-provider-vault_2.13.0_linux_amd64.zip
rm terraform-provider-aws_3.5.0_linux_amd64.zip
rm terraform-provider-vault_2.13.0_linux_amd64.zip
cd $WORKDIR
```

2. Create the `Dockerfile`

```
# This Dockerfile builds the image used for the worker containers.
# This Dockerfile builds the image used for the worker containers.
FROM ubuntu:xenial

# Install software used by Terraform Enterprise.
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo unzip daemontools git-core awscli ssh wget curl psmisc iproute2 openssh-client redis-tools netcat-openbsd ca-certificates

# Include all necessary CA certificates.
ADD root-ca.crt /usr/local/share/ca-certificates/
ADD intermediate-ca.crt /usr/local/share/ca-certificates/

# Update the CA certificates bundle to include newly added CA certificates.
RUN update-ca-certificates

ADD ./terraform.d /root/.terraform.d
```

3. Build image

`docker build -t bp2i_tfe_worker:latest .`

4. Export the Image 

`docker save bp2i_tfe_worker:latest | gzip > bp21_tfe_worker.tar.gz`

5. Copy the image to TFE host (ssh, ftp... )

6. Import the image in TFE

`docker load < bp21_tfe_worker.tar.gz`

7. List image

`docker image ls bp2i_tfe_worker`

```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
bp2i_tfe_worker     latest              33ed738fd193        3 minutes ago       534MB
```

8. Configure the alternative worker image

1. Access https://<TFE-HOST>/settings#worker_image

2. Set the `Custom image tag` with the image name `bp2i_tfe_worker:latest`

3. Save and restart the TFE

