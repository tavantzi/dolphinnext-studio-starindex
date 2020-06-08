DolphinNext docker version
========
DolphinNext original repository is located at https://github.com/UMMS-Biocore/dolphinnext.

For a quick start please check our quick start guide. https://dolphinnext.readthedocs.io/en/latest/dolphinNext/quick.html

DolphinNext can also be run as a standalone application using a docker container.
First docker image need to be build unless you want to use prebuild from dockerhub. So, any change in the Dockerfile requires to build the image. But if you want to use prebuild version just skip building it and start the container.

Pull docker image
---------

1. docker pull tavantzi/dolphinnext-studio-startindex

Start the container
---------

1. We move database outside of the container to be able to keep the changes in the database everytime you start the container.
Please choose a directory in your machine to mount and replace `/path/to/mount` with your path. 
* Note: Please don't change the target directory(`/export`) in the docker image. 

```
mkdir -p /path/to/mount
```

2. While running the container;
```
docker run -m 10G -p 8080:80 -v /path/to/mount:/export -ti dolphinnext-studio-startindex /bin/bash
```

3. After you start the container, you need to start the mysql and apache server usign the command below;
```
startup
```
4. Now, you can open your browser to access dolphinnext using the url below.

http://localhost:8080/dolphinnext

Running on the Amazon or Google Cloud
------
We define `localhost:8080` in /path/to/mount/dolphinnext/config/.sec file and use that to log in or other operations. You need to change `localhost` to that IP address or amazon/google domain you use. So static IP address and domainname would solve the issue that you will not need to change it every time you create an instance. Please update `BASE_PATH` and `PUBWEB_URL` as follows:

```
BASE_PATH = http://localhost:8080/dolphinnext
PUBWEB_URL = http://localhost:8080/dolphinnext/tmp/pub
```

to
```
BASE_PATH = http://your_temporary_domain_name:8080/dolphinnext
PUBWEB_URL = http://your_temporary_domain_name:8080/dolphinnext/tmp/pub
```
* Please don't change other lines because others are used inside of docker.
