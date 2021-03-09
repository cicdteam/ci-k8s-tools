FROM alpine:3

ARG KUBECTL_VERSION=1.19.7
ARG HELM_VERSION=3.5.2
ARG KUSTOMIZE_VERSION=3.5.4


# install some tools

RUN set -e \
	&& apk add --no-cache --virtual .rundeps \
		ca-certificates \
		curl \
		bash \
		jq

# install kubectl

RUN set -e \
	&& curl -sfSL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
	&& chmod +x /usr/local/bin/kubectl

# install helm

RUN set -e \
	&& curl -sfSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz |tar xz \
	&& mv linux-amd64/helm /usr/local/bin/helm \
	&& chmod +x /usr/local/bin/helm \
	&& rm -rf linux-amd64

# install kustomize

RUN set -e \
	&& curl -sfSL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz | tar xz \
	&& mv kustomize /usr/local/bin/kustomize \
	&& chmod +x /usr/local/bin/kustomize

CMD ["/bin/sh", "-c", "echo -n 'kubectl: '; kubectl version --client --short; echo -n 'helm: '; helm version --short; echo -n 'kustomize: '; kustomize version --short"]
