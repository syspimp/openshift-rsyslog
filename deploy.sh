#!/bin/bash
echo "If you leave this unmodified, it will forward all traffic to port 30514 locally on all of your worker nodes"
echo "This is because I deployed syspimp/openshift-zenoss4 and it creates nodePort 30514 to access syslog traffic from the nodes"
echo "Modify the daemonset*yaml file to change the LOG_SERVER target to your syslog host"
echo "and modify the configmap*yaml file to uncomment the LOG_SERVER"
echo "Press enter to continue"
read line

oc create namespace openshift-logging
oc create sa logcollector -n openshift-logging
oc create role log-collector-privileged \
    --verb use \
    --resource securitycontextconstraints \
    --resource-name privileged \
    -n openshift-logging
oc create rolebinding log-collector-privileged-binding \
    --role=log-collector-privileged \
    --serviceaccount=openshift-logging:logcollector \
     -n openshift-logging
oc create -f openshift/configmap-rsyslogd-config.yaml -n openshift-logging
oc create -f openshift/daemonset-rsyslogd.yaml -n openshift-logging
oc create -f openshift/configmap-snmpd-config.yaml -n openshift-logging
oc create -f openshift/daemonset-snmpd.yaml -n openshift-logging

