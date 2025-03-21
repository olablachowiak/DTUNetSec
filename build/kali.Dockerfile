FROM kasmweb/kali-rolling-desktop:1.16.0 AS base
USER root

ENV HOME=/home/kasm-default-profile
ENV STARTUPDIR=/dockerstartup
WORKDIR $HOME

# Install dependencies
RUN apt update && apt install -y --no-install-recommends \
    build-essential libssl-dev libffi-dev python3-dev python3-pip python3-venv git \
    evil-winrm iputils-ping ftp \
    ruby-dev \
    && rm -rf /var/lib/apt/lists/* /tmp/*

# Copy material
COPY --chown=1000:0 containers/kali/material material
RUN tar -xzvf material/2-Authentication/impacket-cve-2020-1472.tar.gz -C material/2-Authentication/ \
    && rm material/2-Authentication/impacket-cve-2020-1472.tar.gz

# Add dnscat-2
WORKDIR material
RUN curl -L https://github.com/iagox86/dnscat2/archive/refs/heads/master.tar.gz -o dnscat2.tar.gz \
    && tar -xzvf dnscat2.tar.gz \
    && rm dnscat2.tar.gz \
    && mv dnscat2-master dnscat2
WORKDIR dnscat2/server
RUN bundle install

# Add user sudo privileges
RUN echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Set permissions
RUN chown -R 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

# Final user setup
ENV HOME=/home/kasm-user

WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
