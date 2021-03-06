#!/bin/bash -e

# TODO: Fix this error:
# /tmp/install-aws-cli.sh: line 3: [: -e: binary operator expected
# /usr/lib/python2.6/site-packages/pip/_vendor/requests/packages/urllib3/util/ssl_.py:90: InsecurePlatformWarning: A
# true SSLContext object is not available. This prevents urllib3 from configuring SSL appropriately and may cause
# certain SSL connections to fail. For more information, see
# https://urllib3.readthedocs.org/en/latest/security.html#insecureplatformwarning.
# InsecurePlatformWarning

PIPCMD=''
if which pip3 >/dev/null ; then
  PIPCMD="$(which pip3)"
elif which pip >/dev/null ; then
  PIPCMD="$(which pip)"
fi

PYCMD=python
if which python3 >/dev/null ; then
  PYCMD=python3
fi

if [ -z $PIPCMD ] ; then
  if [ ! -e ./get-pip.py ] ; then
    # Only download if it hasn't already been downloaded
    curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
  fi
  $PYCMD ./get-pip.py
fi

# Fix for Ubuntu which puts pip into /usr/local/bin but which doesn't have /usr/local/bin
# in the path by default (at least under Test Kitchen)
if ! env | grep ^PATH | grep '/usr/local/bin' > /dev/null ; then
  export PATH=$PATH:/usr/local/bin
fi
$PIPCMD install awscli
