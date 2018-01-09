# Enunciado: https://moodle.lab.dit.upm.es/pluginfile.php/16080/mod_resource/content/16/cnvr-p7.pdf

# Copy new XML to that folder
cp conf/openstackodl.xml /mnt/tmp
# Move to temp directory
cd /mnt/tmp
# Download and extract project, if not present
if [ ! -d openstack_lab-ocata_4n_classic_ovs-v01 ]; then
	/mnt/vnx/repo/cnvr/bin/get-openstack-tutorial.sh
fi
# Move to download directory
cd openstack_lab-ocata_4n_classic_ovs-v01
# Copy new XML to that folder
cp ../openstackodl.xml .
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

# Console text colors
COLOR='\033[0;36m'
NC='\033[0m' # No Color

# End echoes
echo -e ""
echo -e "To show map:"
echo -e "   ${COLOR}sudo vnx -f openstackodl.xml -v --show-map${NC}"
echo -e ""
echo -e "URL of admin panel: http://10.0.10.11/horizon"
echo -e "   domain:   ${COLOR}default${NC}"
echo -e "   user:     ${COLOR}admin${NC}"
echo -e "   password: ${COLOR}xxxx${NC}"
