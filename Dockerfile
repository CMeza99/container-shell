FROM registry.fedoraproject.org/fedora:rawhide

ADD dotfiles/* /root/

RUN cd && set -ex && \
  sed -i --expression 's/nodocs//' /etc/dnf/dnf.conf &&\
  dnf --assumeyes update coreutils-single curl &&\
  dnf --assumeyes update --nodocs  &&\
  dnf --assumeyes install --nodocs neovim unzip ruby &&\
  dnf --assumeyes install sudo man bash-completion git openssh-clients jq findutils tmux iputils ldns-utils bind-utils nmap which file lastpass-cli &&\
  dnf --assumeyes install --nodocs make gcc libffi-devel redhat-rpm-config ruby-devel \
    zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel &&\
  ln -s /usr/bin/sha1sum /usr/bin/shasum &&\
  useradd -m -G wheel -c 'Default User' digitalr00ts &&\
  echo '%wheel	ALL=(ALL)NOPASSWD: ALL' > /etc/sudoers.d/wheel-passwordles &&\
  ln -s /shared /home/digitalr00ts/shared &&\
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
  dnf --assumeyes remove redhat-rpm-config ruby-devel &&\
  dnf --assumeyes autoremove &&\
  dnf --assumeyes clean all &&\
  find /etc -name \*.rpmnew -delete &&\
  rm -rf -- /root/.cache

USER digitalr00ts:digitalr00ts

WORKDIR /home/digitalr00ts

CMD [ 'bash' ]
