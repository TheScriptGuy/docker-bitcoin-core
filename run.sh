REPOSITORY="myrepo"
IMAGE_NAME="bitcoin-node"
IMAGE_VERSION="1.0"
IMAGE_TAG="$REPOSITORY/$IMAGE_NAME:$IMAGE_VERSION"

CONTAINER_NAME="bitcoin-node1"
CONTAINER_NAME_OLD="$CONTAINER_NAME-old"

CONTAINER_IP="192.168.1.100"
CONTAINER_NETWORK="network"

BITCOIN_STORAGE=/storage3/docker/bitcoin-core

if [ "$(docker ps -aq -f name=$CONTAINER_NAME_OLD)" ]; then
    # If it does, remove it
    echo "Removing old container."
    docker rm -f $CONTAINER_NAME_OLD
fi

# Check if the container container1 exists
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping container $CONTAINER_NAME_OLD"
    docker stop $CONTAINER_NAME
    
    # If it does, rename it to $CONTAINER_NAME_OLD
    echo "Renaming current container."
    docker rename $CONTAINER_NAME $CONTAINER_NAME_OLD
fi

docker create -v $BITCOIN_STORAGE/data:/data \
    -v $BITCOIN_STORAGE/bitcoin-user:/home/bitcoin \
    --name=$CONTAINER_NAME \
    --network=$CONTAINER_NETWORK \
    --ip=$CONTAINER_IP \
    --cpus="10" \
    --memory="8192m" \
    $IMAGE_TAG

docker start $CONTAINER_NAME
