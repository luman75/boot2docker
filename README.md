# Generator of boot2image.iso for OSX

This docker prepares an environment generating properly boot2docker.iso on OSX for OSX.
The original boot2docker/boot2docker image is not working proplery for me. 

The problem relates to inconsitency of the boot2docker.iso generate as the result of command
> docker run --rm boot2docker/boot2docker > boot2docker.iso
For some reasons boot2docker.iso is not consisted with the one genered inside the docker process machine. 


Additional problem I've come accross is lack of proper rights on shared directories from OSX. 
Boot2docker automatically mounts /Users directory to the docker vm. However vboxfs which is exploited there is not properly 
preserving ownership of the created files. In results there are some cases when process creating a file is not able to read that file
due to lack of permission. To avoid that problem this boot2image.iso loader is mounting _/Users_ directory with mask 0777, so all the files 
virtually inside the docker machine stored on the shared folders will be seen as accessible for everyone. This is workaround well known problem with VBox sharing. 

This docker generates as well boot2docker.iso including tools for phusion/baseimage-docker. Now docker-ssh, docker-bash are loaded and then can be easily proxied to OSX.


This docker app works diffrently then the original one. To run please use the following command:
> mkdir outiso
> docker run --rm -t -i -v `pwd`/outiso/:/outiso luman75/boot2docker

The output boot2docker image will be held in outiso directory. The file boot2docker.iso should be coppied to your ~/.boot2docker
> cp outiso/boot2docker.iso ~/.boot2docker

Now it's time to restart your boot2docker
> boot2docker down
> boot2docker up

To check if this is working properly try to login to boot2docker VM using
> boot2docker ssh

and now check permission of the files in _/Users_ directory.

>docker@boot2docker:~$ ls -la /Users
>total 0
>drwxrwxrwx    1 docker   staff          204 Oct 17 10:56 ./
>drwxr-xr-x   18 root     root           420 Dec 22 19:38 ../
>-rwxrwxrwx    1 docker   staff            0 Sep  9 22:16 .localized
>drwxrwxrwx    1 docker   staff          408 Apr 17  2013 Guest/
>drwxrwxrwx    1 docker   staff          442 Oct 17 10:56 Shared/
>drwxrwxrwx    1 docker   staff         5508 Dec 22 09:33 XXXXXX/
>docker@boot2docker:~$ 


If everything went ok, all files should have _0777_ rights. 



## Proxing docker-bash 
Because the VM machine now is equipped with docker-bash and docker-ssh tools for phusion/baseimage-docker you need to create a local (OSX) scripts tunneling requests to VM. 

This is example _docker-bash_ script:
>#!/bin/sh                                                                                                               
>                                                                                                                        
>/usr/local/bin/boot2docker ssh -t "sudo docker-bash $@" 

