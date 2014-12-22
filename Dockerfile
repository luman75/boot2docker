FROM boot2docker/boot2docker

# tools for image builders it won't be included in the boot2docker.iso 
RUN apt-get -y install mc

# install docker-bash and docker-ssh for phusion based machines
RUN cd /root && \
	curl --fail -L -O https://github.com/phusion/baseimage-docker/archive/master.tar.gz && \
	tar xzf master.tar.gz

ADD install-tools.sh /root/baseimage-docker-master/install-tools.sh

RUN cd /root && \
	./baseimage-docker-master/install-tools.sh

#we need to correct mouting options to avoid problem with permission errors
RUN sed -i "s/mountOptions='defaults'/mountOptions='dmode=0777,fmode=0777'/" /rootfs/etc/rc.d/automount-shares

ADD geniso.sh /geniso.sh

VOLUME ["/outiso"]

# This should be the last RUN
CMD ["/geniso.sh"]