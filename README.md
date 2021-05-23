# Terraform used to Create an Ansible-master & Ansible Clients (NB: Ansible master hosts file is automatically generated with client details) 
[![Builds](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

## Description:
The ansible infrastructure is created through terraform (IAC). All the details are fetching through a bash script. So, you don't need to change anything manually all are working automatically but some values are appending with your answer. Also, the infrastructure includes one ansible master server (Constant Redhat Distributer), two ansible client servers (Choosable Redhat/Debian Distributer) please note that both client servers with the same distributor which you opt for. In addition, you can choose both master/client's Instance type would you be like also you can use the infrastructure where you want. Furthermore, Terraform installation is included in the script and It's working with your AWS cloud and your default VPC if anyone needs to connect VPC with the infrastructure please ping me via LinkedIn.

## Feutures: 
- Easy to use and create a ansible infrastructure (only two clients)
- Client operating system is choosable (Debian/Redhat)
- Instance Type is choosable (Both Master/Client)
- You can use this code at wherever in AWS Cloud
- Terraform installation included 
- Ansible installtion is included (Master)
- Master server creates hosts file (with your two clients private IP) (/root/ -- hosts file location in master)
## Used Languages:
- Terraform - HCL (For Infrastructure Making)
- Bash (For automating HCL infrastructure making)

## Used Resources/ Dependencies: 
- 3 EC2 Instances (1 Ansible Master, 2 Ansible Clients)
- 2 Security Groups (Open Ports: SSH for Master, SSH,HTTP,MySQL for clients)
- IAM Role (IAM Role with EC2 Describe)
- Key Pair (Login to these servers key.pem is the name)
- Default VPC (On your infrastructure)

# How to use the Script:
```sh
 git clone https://github.com/yousafkhamza/ansible_infra_making_terraform.git
 cd ansible_infra_making_terraform/
 chmod +x setup.sh
 sh setup.sh
```
# Sample Screenshots
> setup.sh script sample screenshots
- _Banner_
![alt text](https://i.ibb.co/L9CQfXv/Banner.png)
- _Screenshot 1_
![alt text](https://i.ibb.co/hHxkhrV/1.png)
- _Screenshot 2_
![alt text](https://i.ibb.co/rGwgVgw/2.png)
- _Screenshot 3_
![alt text](https://i.ibb.co/6DFCJqf/3.png)
- _Screenshot 4_
![alt text](https://i.ibb.co/LCgFzqq/4.png)
- _Screenshot 5_
![alt text](https://i.ibb.co/b5WGmt8/5.png)
- _Screenshot 6_
![alt text](https://i.ibb.co/v1gL4Lw/6.png)
> you can check the ansible master and client connection with the below ansible command (After infrastructure creation)
- Login to your Ansible-Master server (_screenshot 5_) 
```sh
ssh -i key.pem ec2-user@public_ip     <========= this public_ip will be printed so please use that ip with the same
```
- Client conncetion checking through Ansible (_screenshot 6_)
```sh
ansible  -i hosts all --list-hosts

ansible -i hosts all -f 1 -m ping
```

# Conclution:  
This is only for creating one master and two clients ansible infrastructure.

# _*stay home stay safe*_ 
_yousaf k hamza_
