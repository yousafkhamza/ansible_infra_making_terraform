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
printf "\e[1;92m                      ____       _                 _                          \e[0m\n"
printf "\e[1;92m                     / ___|  ___| |_ _   _ _ __   (_)_ __                     \e[0m\n"
printf "\e[1;92m                     \___ \ / _ \ __| | | | '_ \  | | '_ \                    \e[0m\n"
printf "\e[1;92m                      ___) |  __/ |_| |_| | |_) | | | | | |                   \e[0m\n"
printf "\e[1;92m                     |____/ \___|\__|\__,_| .__/  |_|_| |_|                   \e[0m\n"
printf "\e[1;92m                                          |_|                                 \e[0m\n"
printf "\e[1;92m                _____                    __                                   \e[0m\n"
printf "\e[1;92m               |_   _|__ _ __ _ __ __ _ / _| ___  _ __ _ __ ___               \e[0m\n"
printf "\e[1;92m                 | |/ _ \ '__| '__/ _' | |_ / _ \| '__| '_ ' _ \              \e[0m\n"
printf "\e[1;92m                 | |  __/ |  | | | (_| |  _| (_) | |  | | | | | |             \e[0m\n"
printf "\e[1;92m                 |_|\___|_|  |_|  \__,_|_|  \___/|_|  |_| |_| |_|             \e[0m\n"
printf "\n"
printf "\e[1;77m\e[45m      Ansible-Setup through terrafrom v1 Author: @yousafkhamza (Github)     \e[0m\n"
printf "\n"

echo ""
echo "..................Welcome to the Script.................."
echo "Let's start to create a Ansible Infrastructure through Terraform...."
echo ""

rm -f ansi* userdata.sh
userdata=`cat .userdata.txt`
cat <<EOF >userdata.sh
$userdata
EOF
rm -f ./terraform.tfvars
cat <<EOF >terraform.tfvars
region          = "-REGION-"
mtype           = "-MTYPE-"
ctype           = "-CTYPE-"
EOF

read -p "Please specify your region: " reg
if [ -z $reg  ]; then
echo "No region value entered"
exit 1
else
        sed -i "s/-REGION-/"$reg"/" ./terraform.tfvars
        sed -i "s/-REGION-/"$reg"/" ./userdata.sh
fi

read -p "Please specify your Master instance tpye: " mty
if [ -z $mty  ]; then
echo "No master instance type value entered"
exit 1
else
        sed -i "s/-MTYPE-/"$mty"/" ./terraform.tfvars
fi

read -p "Please specify your Clients instance tpye: " cty
if [ -z $cty  ]; then
echo "No master instance type value entered"
exit 1
else
        sed -i "s/-CTYPE-/"$cty"/" ./terraform.tfvars
fi

read -p "Please choose Your Ansible OS type (Redhat or Debian)[r/d]: " string

if [[ -f ansi.pub ]]; then
echo "Key is already available"
else
ssh-keygen -b 2048 -t rsa -f ansi -q -N ""
ansipub=`cat ./ansi.pub`
fi

if [[ -f ansi.pub ]]; then
ansikey=`cat ansi`
eo=EOF
cat <<EOF >> userdata.sh
cat <<EOF > /root/ansible.pem
$ansikey
$eo

sudo chmod 400 /root/ansible.pem
rm -f txt
EOF
else
        echo "key file is not created"
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
echo "start to connect provider.tf to terraform.........."
echo ""
terraform init
;;
*)
        ehco ""
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
        echo "Please choose one environment"
        echo ""
else
case "$string" in
redhat|REDHAT|Redhat|red|RED|hat|HAT|r|R)
sed -i '/env/d'                 ./terraform.tfvars
echo 'env       = "-value-"' >> ./terraform.tfvars
sed -i "s/-value-/"linux"/"     ./terraform.tfvars
cat <<EOF >> userdata.sh
echo "[amazon]" > /root/hosts
echo -e $ipone 'ansible_user="ec2-user" ansible_port=22 ansible_ssh_private_key_file="/root/ansible.pem"' >> /root/hosts
echo -e $iptwo 'ansible_user="ec2-user" ansible_port=22 ansible_ssh_private_key_file="/root/ansible.pem"' >> /root/hosts
EOF
;;
debian|Debian|DEBIAN|deb|DEB|d|D)
sed -i '/env/d'                  ./terraform.tfvars
echo 'env       = "-value-"' >> ./terraform.tfvars
sed -i "s/-value-/"ubuntu"/" ./terraform.tfvars
cat <<EOF >> userdata.sh
echo "[amazon]" > /root/hosts
echo -e $ipone 'ansible_user="ubuntu" ansible_port=22 ansible_ssh_private_key_file="/root/ansible.pem"' >> /root/hosts
echo -e $iptwo 'ansible_user="ubuntu" ansible_port=22 ansible_ssh_private_key_file="/root/ansible.pem"' >> /root/hosts
EOF
;;
*)
echo "Only chose production or development"
;;
esac
fi

echo ""
read -p "Proceed to apply this to infrastructure [y|N]: " infra
case "$infra" in
yes|YES|y|Y)
        terraform validate

        terraform apply -auto-approve
sleep 2
echo ""
echo "Your Ansible Infrastructure is functionable......................"
echo ""
echo "................Thank_you................"
echo "..............Yousaf K Hamza................"
echo "..........yousaf.k.hamza@gmail.com................"
;;
*)
        echo "Please re-run the script or terrafom apply manually"
;;
esac