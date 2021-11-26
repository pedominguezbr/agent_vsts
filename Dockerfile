FROM ubuntu:18.04
RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

#Update and Upgrade to latest version
RUN apt update && apt upgrade -y

#Install required files
RUN DEBIAN_FRONTEND="noninteractive"  apt install curl libunwind8 gettext wget nano docker.io docker-compose -y
RUN apt-get install -y --no-install-recommends ca-certificates curl jq git iputils-ping libcurl4 libicu60 libunwind8 netcat default-jdk zip unzip chromium-browser

RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/*

#################Instal NODE
ENV NODE_VERSION 14.16.1
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version


#################Fin Instal NODE

##Install CRHOMIUN
#RUN apt-get install chromium-browser
#RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#RUN apt-get install gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils
#RUN dpkg -i google-chrome-stable_current_amd64.deb
#RUN apt-get update && apt-get install -y chrome

#################Instal powershell
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
RUN dpkg -i packages-microsoft-prod.deb
# Update the list of products
RUN apt-get update && apt-get install -y \
    powershell

#################Fin Instal powershell

#################Instal helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
  && chmod 700 get_helm.sh \
  && ./get_helm.sh
#################Fin Instal helm

#################Instal terraform
RUN wget --quiet https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip \
  && unzip terraform_1.0.11_linux_amd64.zip \
  && mv terraform /usr/local/bin/ \
  && rm terraform_1.0.11_linux_amd64.zip \
  && terraform --version
#################Fin terraform

ARG TARGETARCH=amd64
ARG AGENT_VERSION=2.195.0

WORKDIR /azp
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz; \
    else \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${TARGETARCH}-${AGENT_VERSION}.tar.gz; \
    fi; \
    curl -LsS "$AZP_AGENTPACKAGE_URL" | tar -xz

COPY ./start.sh .
RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]