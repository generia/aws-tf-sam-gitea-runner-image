# syntax=docker/dockerfile:1.6
FROM docker.gitea.com/runner-images:ubuntu-22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH
ARG TERRAFORM_VERSION=1.6.6

ENV TF_PLUGIN_CACHE_DIR=/opt/terraform/plugin-cache
ENV TF_CLI_CONFIG_FILE=/etc/terraformrc
ENV TF_IN_AUTOMATION=true

RUN apt-get update && apt-get install -y --no-install-recommends     ca-certificates curl unzip jq python3 python3-pip  && rm -rf /var/lib/apt/lists/*

RUN case "${TARGETARCH}" in       amd64) TF_ARCH=amd64 ;;       arm64) TF_ARCH=arm64 ;;       *) exit 1 ;;     esac &&     curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TF_ARCH}.zip -o /tmp/terraform.zip &&     unzip /tmp/terraform.zip -d /usr/local/bin && rm /tmp/terraform.zip

RUN case "${TARGETARCH}" in       amd64) AWS_ARCH=x86_64 ;;       arm64) AWS_ARCH=aarch64 ;;       *) exit 1 ;;     esac &&     curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip -o /tmp/aws.zip &&     unzip /tmp/aws.zip -d /tmp && /tmp/aws/install --update && rm -rf /tmp/aws /tmp/aws.zip

RUN case "${TARGETARCH}" in       amd64) SAM_ARCH=x86_64 ;;       arm64) SAM_ARCH=arm64 ;;       *) exit 1 ;;     esac &&     curl -fsSL https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-${SAM_ARCH}.zip -o /tmp/sam.zip &&     unzip /tmp/sam.zip -d /tmp/sam && /tmp/sam/install --update && rm -rf /tmp/sam /tmp/sam.zip

COPY terraform/terraformrc /etc/terraformrc
RUN mkdir -p /opt/terraform/plugin-cache
COPY terraform/seed-providers /opt/seed-providers
RUN bash /opt/seed-providers/seed.sh && rm -rf /opt/seed-providers
WORKDIR /workspace
