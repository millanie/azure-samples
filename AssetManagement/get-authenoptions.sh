#!/bin/bash

az vm list -o table | awk '{print "az vm show -n " $1 " -g " $2 }' | grep -v "\-\-\-" | grep -v ResourceGroup > /tmp/tempquery.sh

export postfix=" --query '{rgName:resourceGroup ,vmName:name, KeyAuthentication:osProfile.linuxConfiguration.disablePasswordAuthentication}' -o table;"

cat /tmp/tempquery.sh | while read line; do echo ${line}$postfix; done > /tmp/vm-check.sh

outfile="/tmp/vm-check.txt"

# sh /tmp/vm-check.sh > $outfile
# cat $outfile | grep "True"

