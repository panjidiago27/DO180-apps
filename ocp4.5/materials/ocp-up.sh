#!/usr/bin/bash
up=$(oc cluster status | grep started | wc -l)
if [ $up -eq 0 ]; then
  oc cluster up --public-hostname='master.lab.example.com' --host-data-dir='/var/lib/origin/etcd' --use-existing-config --image='registry.lab.example.com/openshift3/ose' --version='v3.9' --routing-suffix='apps.lab.example.com'
  oc login -u system:admin &>/dev/null
  oc adm policy add-cluster-role-to-user cluster-admin developer &>/dev/null
  oc delete -n openshift is php &>/dev/null
  oc delete -n openshift is nodejs &>/dev/null
  cat <<EOF | oc create -n openshift -f - &>/dev/null
apiVersion: v1
kind: ImageStream
metadata:
  annotations:
    openshift.io/display-name: PHP
    openshift.io/image.dockerRepositoryCheck: 2017-04-08T13:06:07Z
  creationTimestamp: null
  generation: 2
  name: php
spec:
  tags:
  - annotations:
      description: Build and run PHP 5.5 applications on CentOS 7. For more information
        about using this builder image, including OpenShift considerations, see https://github.com/sclorg/s2i-php-container/blob/master/5.5/README.md.
      iconClass: icon-php
      openshift.io/display-name: PHP 5.5
      sampleRepo: https://github.com/openshift/cakephp-ex.git
      supports: php:5.5,php
      tags: builder,php
      version: "5.5"
    from:
      kind: DockerImage
      name: 172.30.167.60:5000/openshift/php:5.5
    generation: 2
    importPolicy: {}
    name: "5.5"
  - annotations:
      description: Build and run PHP 5.6 applications on RHEL 7. For more information
        about using this builder image, including OpenShift considerations, see https://github.com/sclorg/s2i-php-container/blob/master/5.6/README.md.
      iconClass: icon-php
      openshift.io/display-name: PHP 5.6
      sampleRepo: https://github.com/openshift/cakephp-ex.git
      supports: php:5.6,php
      tags: builder,php
      version: "5.6"
    from:
      kind: DockerImage
      name: registry.lab.example.com/rhscl/php-56-rhel7:latest
    generation: 2
    importPolicy:
      insecure: true
    referencePolicy:
      type: Local
    name: "5.6"
  - annotations:
      description: |-
        Build and run PHP applications on CentOS 7. For more information about using this builder image, including OpenShift considerations, see https://github.com/sclorg/s2i-php-container/blob/master/5.6/README.md.

        WARNING: By selecting this tag, your application will automatically update to use the latest version of PHP available on OpenShift, including major versions updates.
      iconClass: icon-php
      openshift.io/display-name: PHP (Latest)
      sampleRepo: https://github.com/openshift/cakephp-ex.git
      supports: php
      tags: builder,php
    from:
      kind: DockerImage
      name: 172.30.167.60:5000/openshift/php:latest
    generation: 1
    importPolicy: {}
    name: latest
status:
  dockerImageRepository: ""
EOF
  cat <<EOF | oc create -n openshift -f - &>/dev/null
apiVersion: v1
kind: ImageStream
metadata:
  annotations:
    openshift.io/display-name: Node.js
    openshift.io/image.dockerRepositoryCheck: 2017-04-24T11:45:41Z
  creationTimestamp: null
  generation: 2
  name: nodejs
spec:
  tags:
  - annotations:
      description: 'DEPRECATED: Build and run Node.js 0.10 applications on RHEL 7.
        For more information about using this builder image, including OpenShift considerations,
        see https://github.com/sclorg/s2i-nodejs-container/blob/master/0.10/README.md.'
      iconClass: icon-nodejs
      openshift.io/display-name: Node.js 0.10
      sampleRepo: https://github.com/openshift/nodejs-ex.git
      supports: nodejs:0.10,nodejs:0.1,nodejs
      tags: hidden,nodejs
      version: "0.10"
    from:
      kind: DockerImage
      name: 172.30.1.1:5000/openshift/nodejs:0.10
    generation: 2
    importPolicy: {}
    name: "0.10"
    referencePolicy:
      type: Source
  - annotations:
      description: Build and run Node.js 4 applications on RHEL 7. For more information
        about using this builder image, including OpenShift considerations, see https://github.com/sclorg/s2i-nodejs-container/blob/master/4/README.md.
      iconClass: icon-nodejs
      openshift.io/display-name: Node.js 4
      sampleRepo: https://github.com/openshift/nodejs-ex.git
      supports: nodejs:4,nodejs
      tags: builder,nodejs
      version: "4"
    from:
      kind: DockerImage
      name: registry.lab.example.com/rhscl/nodejs-4-rhel7:latest
    generation: 2
    importPolicy:
      insecure: true
    referencePolicy:
      type: Local
    name: "4"
  - annotations:
      description: |-
        Build and run Node.js applications on RHEL 7. For more information about using this builder image, including OpenShift considerations, see https://github.com/sclorg/s2i-nodejs-container/blob/master/4/README.md.

        WARNING: By selecting this tag, your application will automatically update to use the latest version of Node.js available on OpenShift, including major versions updates.
      iconClass: icon-nodejs
      openshift.io/display-name: Node.js (Latest)
      sampleRepo: https://github.com/openshift/nodejs-ex.git
      supports: nodejs
      tags: builder,nodejs
    from:
      kind: DockerImage
      name: 172.30.1.1:5000/openshift/nodejs:latest
    generation: 1
    importPolicy: {}
    name: latest
    referencePolicy:
      type: Source
status:
  dockerImageRepository: ""
EOF
  oc import-image -n openshift php:5.6 &>/dev/null
  oc import-image -n openshift nodejs:4 &>/dev/null
fi
