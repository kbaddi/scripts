# script is to install Docker on rpm (Fedora) based systesm


if [[ -n `sudo rpm -qa | grep -i 'docker'` ]];
then

        echo "Docker Found uninstalling"

        # Uninstall existing docker
        sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine






else
        echo " Docker not found "

fi

# Install required packages

sudo yum install -y yum-utils \
                  device-mapper-persistent-data \
                  lvm2
echo "Installed required Utils"
# Set up Stable Repo
 sudo yum-config-manager \
                  --add-repo \
                  https://download.docker.com/linux/centos/docker-ce.repo


#Install Container-selinux package

# yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.9*.el7.noarch.rpm


# Install Docker CE
if sudo yum install docker-ce
then
       echo "Docker CE Installed"
       # Start Docker service
       sudo systemctl start docker
       # Run Docker
       sudo docker run hello-world
else
       echo "Docker Installation Failed "
fi

