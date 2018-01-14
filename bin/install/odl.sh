#!/bin/bash
# Execute this from OpenStack scenario controller
# Source: https://wiki.opendaylight.org/view/OpenStack_and_OpenDaylight#Installing_OpenDaylight

# =========================================================================
# Download and start OpenDaylight (Karaf 0.7.1)
# =========================================================================

# Download ODL Nytrogen SR1
wget https://nexus.opendaylight.org/content/repositories/public/org/opendaylight/integration/karaf/0.7.1/karaf-0.7.1.tar.gz
# Extract
tar -zxvf karaf-0.7.1.tar.gz
# Remove tar.gz
rm karaf-0.7.1.tar.gz
# Move to directory
cd karaf-0.7.1

# =========================================================================
# Download Java (Oracle JDK 8)
# =========================================================================

# Download and install Oracle JDK, if not found
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install -y oracle-java8-installer
export JAVA_HOME=/usr/lib/jvm/java-8-oracle

# =========================================================================
# Connect to the Karaf shell, and install the odl-ovsdb-openstack bundle, 
# dlux and their dependencies
# =========================================================================

# Start OpenDaylight as a server process, and wait for a while
./bin/start

# Connect to OpenDaylight with the client
./bin/client

# Install features from the client shell
feature:install odl-aaa-authn
feature:install odl-restconf-all
feature:install odl-mdsal-apidocs
feature:install odl-l2switch-switch
feature:install odl-neutron-service
feature:install odl-neutron-northbound-api
feature:install odl-neutron-spi
feature:install odl-neutron-transcriber

# TODO: Make these ones work too
feature:install odl-ovsdb-openstack
feature:install odl-dlux-all

# =========================================================================
# End echoes
# =========================================================================

# General information
echo -e ""
echo -e "URL of DLUX panel: http://10.0.10.11:8181/dlux/index.html"
echo -e "   user:     ${COLOR}admin${NC}"
echo -e "   password: ${COLOR}admin${NC}"
