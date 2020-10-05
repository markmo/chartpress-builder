FROM gcr.io/cloud-builders/gcloud

ARG HELM_VERSION=v2.16.10
ENV HELM_VERSION=$HELM_VERSION

COPY helm.bash /builder/helm.bash

RUN chmod +x /builder/helm.bash && \
  mkdir -p /builder/helm && \
  apt-get update && \
  apt-get install -y curl apt-transport-https ca-certificates build-essential software-properties-common python-software-properties libssl-dev libffi-dev && \
  add-apt-repository ppa:deadsnakes/ppa && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
  apt-get update && \
  apt-get install -y python3.6 python3.6-dev python3-pip docker-ce && \
  curl -SL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz && \
  tar zxvf helm.tar.gz --strip-components=1 -C /builder/helm linux-amd64 && \
  rm helm.tar.gz && \
  apt-get --purge -y autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  python3.6 -m pip install chartpress==0.6.0

ENV PATH=/builder/helm/:$PATH

ENTRYPOINT ["/builder/helm.bash"]
