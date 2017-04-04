#!/bin/bash

curl http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.sh -o /tmp/coreos-current-version.sh 

left=$(cat /tmp/coreos-current-version.sh | grep "VM_NAME" | grep "coreos_production"| cut -d "=" -f 2 | cut -d '-' -f 2)
center=$(cat /tmp/coreos-current-version.sh | grep "VM_NAME" | grep "coreos_production" | cut -d "=" -f 2 | cut -d '-' -f 3)
right=$(cat /tmp/coreos-current-version.sh | grep "VM_NAME" | grep "coreos_production" | cut -d "=" -f 2 | cut -d '-' -f 4 | sed "s/'//")

CURRENT_RELEASE_VERSION=$(echo ${left}.${center}.${right})
echo ${CURRENT_RELEASE_VERSION}

echo "start circle"

for profile in $(ls /opt/coreos-ipxe-server/profiles); do
    USED_RELEASE_VERSION=$(cat /opt/coreos-ipxe-server/profiles/${profile} | jq '.version' | sed 's/\"//g')
    echo ${USED_RELEASE_VERSION}

    if [ "${USED_RELEASE_VERSION}" != "${CURRENT_RELEASE_VERSION}" ]; then
	echo "used release version dont match with current release version from website"
        sed -i "s/${USED_RELEASE_VERSION}/${CURRENT_RELEASE_VERSION}/" /opt/coreos-ipxe-server/profiles/${profile}
    fi
done

if [ ! -d "/opt/coreos-ipxe-server/images/amd64-usr/${CURRENT_RELEASE_VERSION}" ]; then
   mkdir -p /opt/coreos-ipxe-server/images/amd64-usr/${CURRENT_RELEASE_VERSION}
fi

if [ ! -f /opt/coreos-ipxe-server/images/amd64-usr/${CURRENT_RELEASE_VERSION}/coreos_production_pxe.vmlinuz ]; then
   curl -o /opt/coreos-ipxe-server/images/amd64-usr/${CURRENT_RELEASE_VERSION}/coreos_production_pxe.vmlinuz http://stable.release.core-os.net/amd64-usr/${CURRENT_RELEASE_VERSION}/coreos_production_pxe.vmlinuz
fi

if [ ! -f /opt/coreos-ipxe-server/images/amd64-usr/${CURRENT_RELEASE_VERSION}/coreos_production_pxe_image.cpio.gz ]; then
   curl -o /opt/coreos-ipxe-server/images/amd64-usr/${CURRENT_RELEASE_VERSION}/coreos_production_pxe_image.cpio.gz http://stable.release.core-os.net/amd64-usr/${CURRENT_RELEASE_VERSION}/coreos_production_pxe_image.cpio.gz
fi


