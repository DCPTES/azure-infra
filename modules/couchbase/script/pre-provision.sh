#!/bin/bash

echo '******************* update the vm ******************* '
sudo yum update -q -y
echo '******************* updated the vm ******************* '
echo '***************** Installing WGET *****************'
sudo yum install wget -q -y
echo '***************** WGET Installation Done *****************'
echo '***************** Installing Java ******************'
sudo yum install java-1.8.0-openjdk.x86_64 -q -y
echo '******************* Java Installation done******************'
 echo '******************* install pkgconfig******************* '
sudo yum install -q -y pkgconfig
echo '******************* installed pkgconfig******************* '
echo '******************* get couchbase rpm ******************* '
curl -O http://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-5-x86_64.rpm
echo '******************* got couchbase rpm ******************* '
echo '*******************  run couchbase rpm ******************* '
sudo rpm -ivh couchbase-release-1.0-5-x86_64.rpm
echo '******************* ran couchbase rpm ******************* '
echo '******************* install couchbase ******************* '
sudo yum install couchbase-server-6.0.0-1693 -y
echo '******************* installed couchbase  ******************* '
echo '******************* couchbase server status ******************* '
sudo systemctl status couchbase-server
echo '******************* couchbase server status ******************* '
sudo systemctl daemon-reload
