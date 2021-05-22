#!/bin/bash

printf "\e[1;92m         _              _ _     _            __  __           _               \e[0m\n"
printf "\e[1;92m        / \   _ __  ___(_) |__ | | ___      |  \/  | __ _ ___| |_ ___ _ __    \e[0m\n"
printf "\e[1;92m       / _ \ | '_ \/ __| | '_ \| |/ _ \_____| |\/| |/ _' / __| __/ _ \ '__|   \e[0m\n"
printf "\e[1;92m      / ___ \| | | \__ \ | |_) | |  __/_____| |  | | (_| \__ \ ||  __/ |      \e[0m\n"
printf "\e[1;92m     /_/   \_\_| |_|___/_|_.__/|_|\___|     |_|  |_|\__,_|___/\__\___|_|      \e[0m\n"
printf "\e[1;92m                                                                              \e[0m\n"
printf "\e[1;92m                                 _              _                             \e[0m\n"
printf "\e[1;92m                                / \   _ __   __| |                            \e[0m\n"
printf "\e[1;92m                               / _ \ | '_ \ / _' |                            \e[0m\n"
printf "\e[1;92m                              / ___ \| | | | (_| |                            \e[0m\n"
printf "\e[1;92m                             /_/   \_\_| |_|\__,_|                            \e[0m\n"
printf "\e[1;92m                                                                              \e[0m\n"
printf "\e[1;92m           _              _ _     _             ____ _ _            _         \e[0m\n"
printf "\e[1;92m          / \   _ __  ___(_) |__ | | ___       / ___| (_) ___ _ __ | |_       \e[0m\n"
printf "\e[1;92m         / _ \ | '_ \/ __| | '_ \| |/ _ \_____| |   | | |/ _ \ '_ \| __|      \e[0m\n"
printf "\e[1;92m        / ___ \| | | \__ \ | |_) | |  __/_____| |___| | |  __/ | | | |_       \e[0m\n"
printf "\e[1;92m       /_/   \_\_| |_|___/_|_.__/|_|\___|      \____|_|_|\___|_| |_|\__|      \e[0m\n"
printf "\e[1;92m                                                                              \e[0m\n"
printf "\e[1;92m                         ____       _                                         \e[0m\n"
printf "\e[1;92m                        / ___|  ___| |_ _   _ _ __                            \e[0m\n"
printf "\e[1;92m                        \___ \ / _ \ __| | | | '_ \                           \e[0m\n"
printf "\e[1;92m                         ___) |  __/ |_| |_| | |_) |                          \e[0m\n"
printf "\e[1;92m                        |____/ \___|\__|\__,_| .__/                           \e[0m\n"
printf "\e[1;92m                                             |_|                              \e[0m\n"
printf "\e[1;92m                _____                    __                                   \e[0m\n"
printf "\e[1;92m               |_   _|__ _ __ _ __ __ _ / _| ___  _ __ _ __ ___               \e[0m\n"
printf "\e[1;92m                 | |/ _ \ '__| '__/ _' | |_ / _ \| '__| '_ ' _ \              \e[0m\n"
printf "\e[1;92m                 | |  __/ |  | | | (_| |  _| (_) | |  | | | | | |             \e[0m\n"
printf "\e[1;92m                 |_|\___|_|  |_|  \__,_|_|  \___/|_|  |_| |_| |_|             \e[0m\n"
printf "\n"
printf "\e[1;77m\e[45m      Ansible-Setup through terrafrom v1 Author: @yousafkhamza (Github)     \e[0m\n"
printf "\n"

echo ""
printf "\033[1;34m ..........................................Welcome to the Script.......................................... \033[0m\n";
printf "\033[1;34m ......................Let's start to create a Ansible Infrastructure through Terraform................... \033[0m\n";

rm -f key* userdata.sh
userdata=`cat .userdata.txt`
touch userdata.sh
cat <<EOF >userdata.sh
$userdata
EOF

rm -f ./terraform.tfvars
cat <<EOF >terraform.tfvars
region          = "-REGION-"
mtype           = "-MTYPE-"
ctype           = "-CTYPE-"
EOF

echo ""
printf "\033[0;31m Please note that please valid values (Region, Instane Type, Operating System Distributer [Redhat/Debian]) \033[0m\n";
printf "\033[0;31m                               Otherwise the script server is not working                                  \033[0m\n";
echo ""
read -p "Please specify your region: " reg
if [ -z $reg  ]; then
echo "Please specify a AWS Region for further script running"
exit 1
else
        sed -i "s/-REGION-/"$reg"/" ./terraform.tfvars
        sed -i "s/-REGION-/"$reg"/" ./userdata.sh
fi

read -p "Please specify your Ansible Master instance tpye: " mty
if [ -z $mty  ]; then
echo "Please enter a instance type value for Master Ansible Server"
exit 1
else
        sed -i "s/-MTYPE-/"$mty"/" ./terraform.tfvars
fi

read -p "Please specify your Ansible Clients instance tpye: " cty
if [ -z $cty  ]; then
echo "Please enter a instance type value for Ansible Client Servers"
exit 1
else
        sed -i "s/-CTYPE-/"$cty"/" ./terraform.tfvars
fi

read -p "Please choose Your Ansible Operating System Distributer (Redhat or Debian) [R/D]: " string

if [[ -f key.pub ]]; then
echo "key.pub is the key of your server and its already created"
else
ssh-keygen -b 2048 -t rsa -f key -q -N ""
echo "Your keypair Name is (key.pem)"
mv -f key key.pem
fi

if [[ -f key.pub ]]; then
ansikey=`cat key.pem`
eo=EOF
cat <<EOF >> userdata.sh
cat <<EOF > /root/key.pem
$ansikey
$eo

sudo chmod 400 /root/key.pem
rm -f txt
EOF
else
        echo "Key file is not created"
fi

#Setup Terrafrom under the current working directory
if [[ -d .terraform ]]; then
        echo ""
        echo "Terrafrom is already installed"
else
echo ""
read -p 'Do you want to install Terraform on this current directory [y/N]: ' con1
case "$con1" in
yes|YES|y|Y)
echo ""
wget https://releases.hashicorp.com/terraform/0.15.3/terraform_0.15.3_linux_amd64.zip 2>&1
unzip terraform*.zip 2>&1
mv -f terraform /usr/bin/
rm -f terraform*.zip
echo ""
echo "Terraform downloading completed...................."
echo ""
sleep 2
echo "Start to Initialise with this directory with terraform.........."
echo ""
terraform init
;;
*)
        echo ""
        echo "Please re-run the script or install terraform manually"
        exit 1
;;
esac
fi

#Linux or Ubuntu Setup
ipone=`cat .a.txt | head -n1`
iptwo=`cat .a.txt | tail -n1`

if [ -z $string  ]; then
        echo ""
        echo "Please Choose one Operating System Distributer (Redhat/Debian)"
        echo ""
else

case "$string" in
redhat|REDHAT|Redhat|RedHat|red|RED|hat|HAT|r|R)
sed -i '/env/d'                 ./terraform.tfvars
echo 'env       = "-value-"' >> ./terraform.tfvars
sed -i "s/-value-/"linux"/"     ./terraform.tfvars
cat <<EOF >> userdata.sh
echo "[amazon]" > /root/hosts
echo -e $ipone 'ansible_user="ec2-user" ansible_port=22 ansible_ssh_private_key_file="/root/key.pem"' >> /root/hosts
echo -e $iptwo 'ansible_user="ec2-user" ansible_port=22 ansible_ssh_private_key_file="/root/key.pem"' >> /root/hosts
EOF
;;

debian|Debian|deb|DEBIAN|DEB|d|D)
sed -i '/env/d'                  ./terraform.tfvars
echo 'env       = "-value-"' >> ./terraform.tfvars
sed -i "s/-value-/"ubuntu"/" ./terraform.tfvars
cat <<EOF >> userdata.sh
echo "[amazon]" > /root/hosts
echo -e $ipone 'ansible_user="ubuntu" ansible_port=22 ansible_ssh_private_key_file="/root/key.pem"' >> /root/hosts
echo -e $iptwo 'ansible_user="ubuntu" ansible_port=22 ansible_ssh_private_key_file="/root/key.pem"' >> /root/hosts
EOF
;;

*)
echo "Unfortunately Redhat or Debian Distributers available"
exit 1
;;
esac
fi

echo ""
read -p "Proceed to apply Ansible servers to your AWS Cloud [y|N]: " infra
case "$infra" in
yes|YES|y|Y)
        terraform validate
echo ""
echo "Lets start to apply ansible infrastructure to your AWS Cloud"
echo ""
sleep 2
        terraform apply -auto-approve
sleep 2
echo ""
echo "Your Ansible Infrastructure is functionable......................"
echo "Ansible master server username is ec2-user"
echo "The command is given below:"
echo "ssh -i key.pem ec2-user@ansible-master-ip (Please check the ouput)"
echo ""
sleep 3
echo ""
echo "................Thank_you................"
echo "..............Yousaf K Hamza................"
echo "..........yousaf.k.hamza@gmail.com................"
;;

*)
        echo "Please re-run the script or terrafom apply manually"
;;
esac
