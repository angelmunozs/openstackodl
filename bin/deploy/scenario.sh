#!/bin/bash
# Enunciado: https://moodle.lab.dit.upm.es/pluginfile.php/16080/mod_resource/content/16/cnvr-p7.pdf
# Download VNX: http://web.dit.upm.es/vnxwiki/index.php/Download

# =========================================================================
# Dependencies
# =========================================================================

# Common content file
source bin/aux/common.sh

# =========================================================================
# Parameters
# =========================================================================

# Scenario name
SCENARIO_NAME=openstack_lab-ocata_4n_classic_ovs-v02

# XML name
XML_NAME=openstackodl.xml

# Working directory
WORKDIR=/tmp

# =========================================================================
# Download scenario, if not found
# =========================================================================

# Copy XML to WORKDIR
cp conf/$XML_NAME $WORKDIR

# Move to directory
cd $WORKDIR

# Download and extract project, if not present
if [ ! -d $SCENARIO_NAME ]; then
	wget http://idefix.dit.upm.es/vnx/examples/openstack/$SCENARIO_NAME-with-rootfs.tgz
	sudo tar -xzf $SCENARIO_NAME-with-rootfs.tgz
	rm $SCENARIO_NAME-with-rootfs.tgz
fi

# =========================================================================
# Start OpenStack and create scenario
# =========================================================================

# Move to download directory
cd $SCENARIO_NAME

# Move here the specification file
sudo mv $WORKDIR/$XML_NAME .

# Create environment
sudo vnx -f $XML_NAME -v --create

# Start server
sudo vnx -f $XML_NAME -v -x start-all

# Download images
sudo vnx -f $XML_NAME -v -x load-img

# Create demo scenario
sudo vnx -f $XML_NAME -v -x create-openstackodl

# Configure NAT
sudo vnx_config_nat ExtNet wlp3s0

# =========================================================================
# End echoes
# =========================================================================

# General information
echo -e ""
echo -e "To show map:"
echo -e "   ${COLOR}sudo vnx -f $XML_NAME -v --show-map${NC}"
echo -e ""
echo -e "URL of admin panel: http://10.0.10.11/horizon"
echo -e "   domain:   ${COLOR}default${NC}"
echo -e "   user:     ${COLOR}admin${NC}"
echo -e "   password: ${COLOR}xxxx${NC}"
