#!/bin/bash

# TODO: Fix this error:
# /tmp/install-aws-cli.sh: line 3: [: -e: binary operator expected
# /usr/lib/python2.6/site-packages/pip/_vendor/requests/packages/urllib3/util/ssl_.py:90: InsecurePlatformWarning: A
# true SSLContext object is not available. This prevents urllib3 from configuring SSL appropriately and may cause
# certain SSL connections to fail. For more information, see
# https://urllib3.readthedocs.org/en/latest/security.html#insecureplatformwarning.
# InsecurePlatformWarning

if [ ! -e get-pip.py ] ; then
  # Only download if it hasn't already been downloaded
  curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
  python get-pip.py
fi

pip install awscli
