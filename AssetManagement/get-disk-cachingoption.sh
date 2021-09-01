#!/bin/bash

az vm list -o table | awk '{print "az vm show -n " $1 " -g "$2 " --show-details" }' | grep -v "\-\-\-" | grep -v ResourceGroup > /tmp/query.sh

export postfix=" --query '{vmName:name,OsDiskName:storageProfile.osDisk.name,OsDiskCaching:storageProfile.osDisk.caching,OsDiskWriteAccelerator:storageProfile.osDisk.writeAcceleratorEnabled,DataDiskName:storageProfile.dataDisks[].name, DataDiskCaching:storageProfile.dataDisks[].caching,DataDiskWriteAccelerator:storageProfile.dataDisks[].writeAcceleratorEnabled}';echo ',';"

vmName:name,OsDiskName:storageProfile.osDisk.name, OsDiskCaching:storageProfile.osDisk.caching,OSwriteAccelerator:storageProfile.osDisk.writeAcceleratorEnabled,DataDiskName:storageProfile.dataDisks[].name,DataDiskCaching:storageProfile.dataDisks[].caching,DatawriteAccelerator:storageProfile.dataDisks[].writeAcceleratorEnabled


cat /tmp/query.sh | while read line; do echo ${line}$postfix; done > /tmp/vm-details.sh

outfile="/tmp/vm-details.json"

sh /tmp/vm-details.sh > $outfile

sed -i '1i {' $outfile
echo "}" >> $outfile

