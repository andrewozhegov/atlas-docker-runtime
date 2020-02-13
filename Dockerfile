FROM arm64v8/ubuntu:bionic

ENV HIAI_USER=HwHiAiUser
ENV HIAI_HOME=/home/${HIAI_USER}
RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo gosu && \
    rm -rf /var/cache/apt/archives/* && \
    useradd --no-log-init --home "${HIAI_HOME}" --create-home --user-group -G sudo --shell /bin/bash ${HIAI_USER} && \
    sed -i "s@^${HIAI_USER}:\!:@${HIAI_USER}::@" /etc/shadow && \
    echo "${HIAI_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${HIAI_USER} && \
    chmod 440 /etc/sudoers.d/${HIAI_USER}

RUN apt-get update && apt-get install -y tzdata

RUN apt-get update && \
    apt-get install --no-install-recommends -y sqlite3 squashfs-tools net-tools vim gcc g++ cmake curl libboost-all-dev libatlas-base-dev liblmdb-dev libhdf5-serial-dev libsnappy-dev libleveldb-dev graphviz libxml2 unzip haveged python-skimage python3-skimage unzip haveged python python-pip python3 python3-pip python-cycler python-decorator python-matplotlib python-numpy python-pil python-pyparsing python-dateutil python-tz python-six python3-cycler python3-decorator python3-matplotlib python3-numpy python3-pil python3-pyparsing python3-dateutil python3-tz python3-six swig openjdk-8-jdk python-setuptools && \
    rm -rf /var/cache/apt/archives/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64
ENV PATH=$PATH:$JAVA_HOME/bin

COPY build/mini_mind_studio_*.rar build/MSpore_DDK-*.tar.gz build/npu_ubuntu.*.zip $HIAI_HOME/
RUN chown $HIAI_USER:$HIAI_USER $HIAI_HOME/mini_mind_studio_*.rar $HIAI_HOME/MSpore_DDK-*.tar.gz $HIAI_HOME/npu_ubuntu.*.zip

COPY entrypoint.sh $HIAI_HOME/
RUN chown $HIAI_USER:$HIAI_USER $HIAI_HOME/entrypoint.sh

RUN apt-get update && \
    apt-get install --no-install-recommends -y libopenblas-dev:arm64 gpg && \
    rm -rf /var/cache/apt/archives/*

RUN mkdir /lib64 && ln -s /lib/aarch64-linux-gnu/ld-2.27.so /lib64/ld-linux-aarch64.so.1

USER $HIAI_USER
WORKDIR $HIAI_HOME

RUN unzip mini_mind_studio_*.rar && rm -f mini_mind_studio_*.rar
RUN sudo $HIAI_HOME/add_sudo.sh $HIAI_USER && $HIAI_HOME/install.sh && \
    rm -f $HIAI_HOME/MSpore_DDK-*.tar.gz Mind-Studio_Ubuntu-*.tar

RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y kmod dkms linux-headers-$(uname -r) pciutils dmidecode && \
    sudo rm -rf /var/cache/apt/archives/*

RUN unzip npu_ubuntu.*.zip && rm -f npu_ubuntu.*.zip
RUN sudo ./npu_ubuntu.*.run --full && rm -f npu_ubuntu.*.run

EXPOSE 8888
EXPOSE 8099

ENTRYPOINT ["/home/HwHiAiUser/entrypoint.sh"]
