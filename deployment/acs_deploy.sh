#!/bin/bash
# You need to have already created an SPN to use this script in a non-interactive session. See local_scripts/create_serviceprincipal.md for more info.

# Read User Input to capture variables needed for deployment
echo "This script will deploy a Docker Swarm Cluster for Azure Container Service to Microsoft Azure."
echo
echo "Enter a name for your Resource Group and press [ENTER]: "
read Resource
echo "The Resource Group Name you entered is $name."
echo "Enter a location for your deployment and press [ENTER]: "
read Location
echo "The Location you entered is $Location."   
echo "Enter a Servicename for your Docker Swarm Cluster and press [ENTER]: "
read Servicename
echo "The service name you entered is $Servicename."
echo "Enter a DNS prefix for your DNS and press [ENTER]: "
read Dnsprefix
echo "The DNS prefix you entered is $Dnsprefix."


echo 
echo "Thank you for your input. Now proceeding with ACS Swarm Deployment..."

#login
    az login \
        --service-principal \
        -u $spn \
        -p $password \
        --tenant $tenant

# Group creation
    az group create \
        -l $Location \
        -n $Resource
    echo "Created Resource Group:" $Resource

    echo "Beginning Azure Container Service creation now. Please note this can take more than 20 minutes to complete."
# ACS Creation for Docker Swarm
    az acs create \
        -g $Resource \
        -n $Servicename \
        -d $Dnsprefix \
        --orchestrator-type Swarm \
        --generate-ssh-keys \
        --verbose

# Space for readabilty
    echo

# Outputs
    # Code to capture ACS master info
        master_fqdn=$(az acs show -n $Servicename -g $Resource | jq -r '.masterProfile | .fqdn')

    # Code to capture ACS agents info
        agents_fqdn=$(az acs show -n $Servicename -g $Resource | jq -r '.agentPoolProfiles[0].fqdn')

    # Set ssh connection string addt'l info
        admin_username=$(az acs show -n $Servicename -g $Resource | jq -r '.linuxProfile.adminUsername')

    # Print results 
        echo "------------------------------------------------------------------"
        echo "Important information:"
        echo 
        echo "SSH Connection String: ssh $admin_username@$master_fqdn -A -p 2200"
        echo "Master FQDN: $master_fqdn"
        echo "Agents FQDN: $agents_fqdn"
        echo "Your web applications can be viewed at $agents_fqdn."
        echo "------------------------------------------------------------------"