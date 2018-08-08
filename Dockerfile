FROM registry.fedoraproject.org/fedora:rawhide

RUN cd && set -ex && \
  sed -i --expression 's/nodocs//' /etc/dnf/dnf.conf &&\
  dnf update --assumeyes --quite coreutils-single curl &&\
  dnf update --assumeyes --quiet --setopt='nodocs' &&\
  dnf install --assumeyes --setopt='tsflags=nodocs' vim &&\
  dnf install --assumeyes man bash-completion git openssh-client jq &&\
  curl --tlsv1.2 --http2 -sL $( \
    curl --tlsv1.2 --http2 -sL https://releases.hashicorp.com/terraform/index.json \
      | jq -r '.versions[].builds[].url' \
      | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n \
      | egrep 'linux.*amd64' \
      | tail -1) \
      > /tmp/terraform.zip &&\
  unzip -d /usr/local/bin/ /tmp/terraform.zip &&\
  curl --tlsv1.2 --http2 -SsL \
    https://download.docker.com/linux/static/stable/x86_64/$( \
      curl --tlsv1.2 --http2 -SsL https://download.docker.com/linux/static/stable/x86_64/ \
        | grep -oE "^<a .*>.*</a>" \
        | tail -1 \
        | sed -e 's/<a[^/]*>//' -e 's/<\/a>//') &&\
  dnf clean all && \
  find /etc -name \*.rpmnew -delete
  rm -rf -- /root/.cache

CMD [ 'bash' ]
