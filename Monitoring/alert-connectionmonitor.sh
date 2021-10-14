#!/bin/bash

tenantID=`az config get law.tenantid --query value -o table | grep -v Result | grep -v "\-\-\-"`
applicationId=`az config get law.spappid --query value -o table | grep -v Result | grep -v "\-\-\-"`
password=`az config get law.sppawd --query value -o table | grep -v Result | grep -v "\-\-\-"`
workspaceid=`az config get law.workspaceid --query value -o table | grep -v Result | grep -v "\-\-\-"`

az login --service-principal --username "${applicationId}" --password "${password}" --tenant "${tenantID}"

QUERY="NWConnectionMonitorTestResult | project TimeGenerated, AvgRoundTripTimeMs, ChecksTotal, ChecksFailed, TestGroupName, TestConfigurationName, SourceName, DestinationName,SourceAddress,DestinationAddress | summarize AvgRTT=round(avg(AvgRoundTripTimeMs),2),FailedCount=sum(ChecksFailed), TotalTests=sum(ChecksTotal) by TestGroupName, SourceName, SourceAddress,DestinationName,DestinationAddress | extend LossPercent = FailedCount * 100 / TotalTests | project TestGroupName, LossPercent, AvgRTT,TotalTests, SourceName, SourceAddress, DestinationName, DestinationAddress"

outfile="/tmp/azmon-result.txt"

az monitor log-analytics query -w "${workspaceid}" --analytics-query "${QUERY}" -o table | grep "PrimaryResult" >> ${outfile}

