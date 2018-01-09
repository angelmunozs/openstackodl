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
# Start OpenDaylight as a server process
./bin/start

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

# Connect to OpenDaylight with the client
./bin/client
# Execute this from the client shell
feature:install odl-base-all:latest odl-aaa-authn:latest odl-restconf:latest odl-adsal-northbound:latest odl-mdsal-apidocs odl-ovsdb-northbound odl-dlux-core odl-nsf-all odl-ovsdb-openstack

# =========================================================================
# End echoes
# =========================================================================

# General information
echo -e ""
echo -e "URL of DLUX panel: http://10.0.10.11:8181/dlux/index.html"
echo -e "   user:     ${COLOR}admin${NC}"
echo -e "   password: ${COLOR}admin${NC}"
