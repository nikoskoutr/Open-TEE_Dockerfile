FROM ubuntu:16.04
RUN apt update
RUN apt install -y nano autoconf automake libtool uuid-dev libssl-dev libglu1-mesa-dev libelf-dev mesa-common-dev build-essential git curl python3.9 htop pkg-config qbs=1.4.5+dfsg-2 gdb libfuse-dev
RUN ln -s /usr/bin/python3.5 /usr/bin/python
RUN git config --global user.name "FIRST SECOND"
RUN git config --global user.email "name@email.com"
RUN git config --global color.ui false
RUN qbs setup-toolchains --detect
RUN qbs config defaultProfile gcc
RUN mkdir -p ~/bin
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
RUN chmod +x ~/bin/repo
RUN mkdir /Open-TEE
RUN cd /Open-TEE ; ~/bin/repo init -u https://github.com/Open-TEE/manifest.git ; exit 0
RUN cd /Open-TEE ; ~/bin/repo init -u https://github.com/Open-TEE/manifest.git ; ~/bin/repo sync -j10 ; exit 0
RUN printf "[PATHS]\nta_dir_path = /Open-TEE/gcc-debug/TAs\ncore_lib_path = /Open-TEE/gcc-debug\nopentee_bin = /Open-TEE/gcc-debug/opentee-engine\nsubprocess_manager = libManagerApi.so\nsubprocess_launcher = libLauncherApi.so" >> /etc/opentee.conf
RUN cd /Open-TEE ; qbs debug
RUN cd /Open-TEE ; ./opentee start
CMD cd /Open-TEE
