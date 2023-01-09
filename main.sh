#!/bin/sh

set -e

CBCFY_BASE64=${CFG_BASE64:="NULL"}
CBCFY_FILE=${CBCFY_FILE:="NULL"}
CBCFY_FLIE_PATH=${CBCFY_FLIE_PATH:="NULL"}
CHAOSBLADE_VERSION=${CHAOSBLADE_VERSION:="LATEST"}

echo "download chaosblade chart"
if [ "$CHAOSBLADE_VERSION" != "LATEST" ]; then
    echo "chaosblade version $CHAOSBLADE_VERSION"
    wget https://github.com/chaosblade-io/chaosblade/releases/download/{$CHAOSBLADE_VERSION}/chaosblade-operator-{$CHAOSBLADE_VERSION}.tgz
else
  echo "chaosblade verison is empty"
  exit 1
fi

echo "check chaosblade experiment configuration yaml"
if [ "$CBCFY_BASE64" != "NULL" ]; then
    echo "$CBCFY_BASE64" | base64 --decode > chaos-experiment.yaml
    CBCFY_FLIE_PATH="./chaos-experiment.yaml"
    echo "--------chaos experiment yaml configuration -----------"
    cat "$CBCFY_FLIE_PATH"
    echo "-------------------------------------------------------"
elif [ "$CBCFY_FLIE" ]; then
    CBCFY_FLIE_PATH=${CBCFY_FLIE}
else
  echo "CBCFY_BASE64 and CBCFY_FILE is empty, can not get chaos experiment configuration"
  exit 2
fi

#echo "install helm3"
#helm version | grep
#curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
#chmod 700 get_helm.sh
#./get_helm.sh


echo "install chaosblade"
helm version
kubectl version
kubectl create ns chaosblade
helm install chaosblade-operator chaosblade-operator-{$CHAOSBLADE_VERSION}.tgz --namespace chaosblade

echo "wait pod status to running"
for ((k=0; k<120; k++)); do
    kubectl get pods --namespace chaos-testing -l part-of=chaosblade > pods.status
    cat pods.status

    run_num=`grep Running pods.status | wc -l`
    pod_num=$((`cat pods.status | wc -l` - 1))
    if [ $run_num == $pod_num ]; then
        break
    fi

    sleep 1
done

kubectl apply -f $CBCFY_FLIE_PATH


