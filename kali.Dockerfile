FROM kasmweb/kali-rolling-desktop:1.16.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

RUN mkdir material
COPY material material

RUN apt -y update \
    && echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && rm -rf /var/lib/apt/lists/

RUN apt -y update \
    && apt install -y --fix-broken \ 
    && apt -y install build-essential libssl-dev libffi-dev python3-dev python3-pip python3-virtualenv git evil-winrm iputils-ping

RUN git clone --depth 1 https://github.com/SecureAuthCorp/impacket \
    && cd impacket/examples \
    && git clone --depth 1 https://github.com/VoidSec/CVE-2020-1472 \
    && chmod +x CVE-2020-1472/cve-2020-1472-exploit.py \
    && cd .. \
    && pwd ~/impacket/ \
    && virtualenv --python=python3 impacket \
    && . impacket/bin/activate \
    && pip install --upgrade pip \
    && pip install . \
    && cd examples/CVE-2020-1472 \
    && pip install -r requirements.txt

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000