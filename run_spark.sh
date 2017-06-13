#! /bin/bash

DOCKER_COMMAND_FRONT="sudo docker run -dit --name"
DOCKER_COMMAND=""
# settings
CPU_SHARES="--cpu-shares 1024"
MEMORY="--memory 12g"
ADDHOST="--add-host=master:10.0.2.2"
DOCKER_COMMAND_LAST="$ADDHOST $MEMORY $CPU_SHARES kmubigdata/ubuntu-spark /bin/bash"

# If You Want to static IP
#IP="10.0.2.”
#START_IP="48"
START_PORT_NUMBER="22006"

numOfContaiers=1

if [[ -z "$4" ]]; then
        echo "format is wrong"
        echo "./add_studnet user-name network-name student-from student-to"
        echo "ex ./add_student kimjc my-net 1 5"
        echo "network is my-net, student from 1, student to 5"
        exit 0
fi

# SSH Login
LOCAL_PUBLIC_KEY="/home/$1/.ssh/id_rsa.pub"
DOCKER_PRIVATE_KEY="/tmp"
DOCKER_COMMAND_MIDDLE="-v $LOCAL_PUBLIC_KEY:$DOCKER_PRIVATE_KEY"

numOfContainers=$3
while [ $numOfContainers != $(($4+1)) ];
do
        idxIP=$(($START_IP+$numOfContainers-1))
        idxPort=$(($START_PORT_NUMBER+$numOfContainers-1))
        # Create Container Spark Image
        DOCKER_COMMAND="$DOCKER_COMMAND_FRONT spark-client$numOfContainers --network $2 --ip $IP$idxIP -p $idxPort:22 $DOCKER_COMMAND_MIDDLE $DOCKER_COMMAND_LAST"
        echo "$DOCKER_COMMAND"
        echo "Create Container Spark-Client"$numOfContainers
        numOfContainers=$(($numOfContainers+1))
done
