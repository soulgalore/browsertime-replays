#!/bin/bash
set -e

google-chrome --version
firefox --version

mitmdump -s "/work/mitmproxy2mahimahi/mitmproxy2mahimahi.py /work/mitmdump"&
NEW_JOB_STARTED="$(jobs -n)"
if [ -n "$NEW_JOB_STARTED" ];then
    PID=$!
else
    PID=
fi

PAGE="https://en.wikipedia.org/wiki/Barack_Obama"
RUNCOUNT=3
MMDELAY=100

/usr/src/app/bin/browsertime.js -n 1 --xvfb --chrome.args proxy-server="127.0.0.1:8080" $PAGE

sudo sysctl -w net.ipv4.ip_forward=1

MAHIMAHI_ROOT=~/mahimahi-h2o mm-webreplay /work/mitmdump noop mm-delay $MMDELAY /usr/src/app/bin/browsertime.js -n $RUNCOUNT --xvfb --video --speedIndex --pageCompleteCheck "return true;" $PAGE
