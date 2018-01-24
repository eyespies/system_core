#!/bin/bash

curl -O https://certs.starfieldtech.net/repository/sf_bundle.crt

# cacert verification fails, use -k and md5 c75ce425e553e416bde4e412439e3d09
curl -k -O https://papertrailapp.com/tools/papertrail-bundle.pem
