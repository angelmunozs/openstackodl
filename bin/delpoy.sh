#!/bin/bash
# Enunciado: https://moodle.lab.dit.upm.es/pluginfile.php/16080/mod_resource/content/16/cnvr-p7.pdf
# Download VNX: http://web.dit.upm.es/vnxwiki/index.php/Download

# =========================================================================
# Parameters
# =========================================================================

# Start time
START_TIME=$SECONDS

# Scenario name
SCENARIO_NAME=openstack_lab-ocata_4n_classic_ovs-v01

# Working directory
WORKDIR=/mnt/tmp

# Console text colors
COLOR='\033[0;36m'
NC='\033[0m' # No Color

# =========================================================================
# Download scenario, if not found
# =========================================================================

# Copy new XML to that folder
cp conf/openstackodl.xml $WORKDIR

# Move to directory
cd $WORKDIR

# Download and extract project, if not present
if [ ! -d $SCENARIO_NAME ]; then
	
	if [ -e ${SCENARIO_NAME} ]; then 
	    echo "--"
	    echo "-- A previous copy of Openstack tutorial scenario found."
	    echo "-- Moving it to /mnt/tmp/old directory"
	    mkdir -p ${WORKDIR}/old
	    mv ${SCENARIO_NAME} ${WORKDIR}/old/${SCENARIO_NAME}-$(date +%S%N)
	    for f in $( ls ${SCENARIO_NAME}*.tgz ); do
	        mv $f ${WORKDIR}/old/$f-$(date +%S%N)
	    done 
	fi

	echo "--"
	echo "-- Copying ${SCENARIO_NAME}-with-rootfs.tgz file..."
	time rsync -ah --progress /mnt/vnx/repo/cnvr/${SCENARIO_NAME}-with-rootfs.tgz .
	echo "--"
	echo "-- Unpacking ${SCENARIO_NAME}-with-rootfs.tgz file..."
	sudo vnx --unpack ${SCENARIO_NAME}-with-rootfs.tgz
	ELAPSED_TIME=$(($SECONDS - $START_TIME))
	echo "--"
	echo "-- Openstack tutorial scenario copied and unpacked in $ELAPSED_TIME seconds"
	echo "--"
fi

# =========================================================================
# Start OpenStack and create scenario
# =========================================================================

# Move to download directory
$SCENARIO_NAME

# Copy new XML to that folder
mv $WORKDIR/openstackodl.xml $WORKDIR/$SCENARIO_NAME

# Create environment
sudo vnx -f openstackodl.xml -v --create

# Start server
sudo vnx -f openstackodl.xml -v -x start-all

# Download images
sudo vnx -f openstackodl.xml -v -x load-img

# Create demo scenario
sudo vnx -f openstackodl.xml -v -x create-openstackodl

# Configure NAT
sudo vnx_config_nat ExtNet eno1

# =========================================================================
# End echoes
# =========================================================================

# General information
echo -e ""
echo -e "To show map:"
echo -e "   ${COLOR}sudo vnx -f openstackodl.xml -v --show-map${NC}"
echo -e ""
echo -e "URL of admin panel: http://10.0.10.11/horizon"
echo -e "   domain:   ${COLOR}default${NC}"
echo -e "   user:     ${COLOR}admin${NC}"
echo -e "   password: ${COLOR}xxxx${NC}"
