FROM registry.fedoraproject.org/fedora:rawhide

ADD dotfiles/* /root/

RUN cd && set -ex && \
  sed -i --expression 's/nodocs//' /etc/dnf/dnf.conf &&\
  dnf --assumeyes update coreutils-single curl &&\
  dnf --assumeyes update --nodocs  &&\
  dnf --assumeyes install --nodocs neovim unzip ruby &&\
  dnf --assumeyes install man bash-completion git openssh-clients jq findutils tmux &&\
  dnf --assumeyes install --nodocs redhat-rpm-config make gcc libffi-devel ruby-devel &&\
  curl --tlsv1.2 --http2 -sL $( \
    curl --tlsv1.2 --http2 -sL https://releases.hashicorp.com/terraform/index.json \
      | jq -r '.versions[].builds[].url' \
      | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n \
      | egrep 'linux.*amd64' \
      | tail -1) \
      > /tmp/terraform.zip &&\
  unzip -d /usr/local/bin/ /tmp/terraform.zip &&\
  rm -f -- /tmp/terraform.zip &&\
  curl --tlsv1.2 --http2 -SsL \
    https://download.docker.com/linux/static/stable/x86_64/$( \
      curl --tlsv1.2 --http2 -SsL https://download.docker.com/linux/static/stable/x86_64/ \
        | grep -oE "^<a .*>.*</a>" \
        | tail -1 \
        | sed -e 's/<a[^/]*>//' -e 's/<\/a>//') \
        | tar -xvzC /tmp &&\
  mv -vf -- /tmp/docker/docker /usr/local/bin/ &&\
  rm -rf -- /tmp/docker &&\
  pip3 --no-cache-dir install docker-compose awscli &&\
  gem install --no-document travis &&\
  echo 'test -s "${HOME}/.ssh/github_ed25519" || ssh-keygen -t ed25519 -o -a 100 -C home@container -N "" -f "${HOME}/.ssh/github_ed25519"' \
    >> ${HOME}/.bashrc &&\
  dnf --assumeyes remove redhat-rpm-config make gcc libffi-devel ruby-devel &&\
  dnf --assumeyes autoremove &&\
  dnf --assumeyes clean all &&\
  find /etc -name \*.rpmnew -delete &&\
  rm -rf -- /root/.cache

CMD [ 'bash' ]
