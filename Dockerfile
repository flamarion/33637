# This Dockerfile builds the image used for the worker containers.
# This Dockerfile builds the image used for the worker containers.
FROM ubuntu:xenial

# Install software used by Terraform Enterprise.
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo unzip daemontools git-core awscli ssh wget curl psmisc iproute2 openssh-client redis-tools netcat-openbsd ca-certificates

# Include all necessary CA certificates.
#ADD root-ca.crt /usr/local/share/ca-certificates/
#ADD intermediate-ca.crt /usr/local/share/ca-certificates/

# Update the CA certificates bundle to include newly added CA certificates.
#RUN update-ca-certificates

ADD ./terraform.d /root/.terraform.d
ADD ./terraform.d/plugins /usr/local/share/terraform/plugins
