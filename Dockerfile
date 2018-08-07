FROM registry.fedoraproject.org/fedora:rawhide

RUN cd && set -ex && \
  sed -i --expression 's/nodocs//' /etc/dnf/dnf.conf && \
  dnf update --assumeyes --quite coreutils-single curl && \
  dnf update --assumeyes --quiet --setopt='nodocs' && \
  dnf install --assumeyes --setopt='tsflags=nodocs' vim
  dnf install --assumeyes man bash-completion git openssh-client && \
  dnf clean all && \
  find /etc -name \*.rpmnew -delete
  rm -rf -- /root/.cache

CMD [ 'bash' ]
