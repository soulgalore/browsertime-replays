#!/bin/bash
set -e

google-chrome --version
firefox --version


RUNS="${RUNS:-5}"
LATENCY=${LATENCY:-100}
BROWSER=${BROWSER:-'chrome'}

echo "Using $GRAPHITE_KEY for Graphite"

webpagereplaywrapper record --start --path /root/go/src/github.com/catapult-project/catapult/web_page_replay_go --http 80 --https 443

if [ $BROWSER = 'chrome' ]
then
    /usr/src/app/bin/browsertime.js -b $BROWSER -n 1 --chrome.args host-resolver-rules="MAP *:80 127.0.0.1:80,MAP *:443 127.0.0.1:443,EXCLUDE localhost" --pageCompleteCheck "return true;" "$@"
else
    /usr/src/app/bin/browsertime.js -b $BROWSER -n 1 --firefox.preference network.dns.forceResolve:127.0.0.1 --firefox.acceptInsecureCerts --skipHar --pageCompleteCheck "return true;" "$@"
fi

webpagereplaywrapper record --stop --path /root/go/src/github.com/catapult-project/catapult/web_page_replay_go --http 80 --https 443

webpagereplaywrapper replay --start --path /root/go/src/github.com/catapult-project/catapult/web_page_replay_go --http 80 --https 443

if [ $BROWSER = 'chrome' ]
then
    /usr/src/app/bin/browsertime.js -b $BROWSER -n $RUNS --chrome.args host-resolver-rules="MAP *:80 127.0.0.1:80,MAP *:443 127.0.0.1:443,EXCLUDE localhost" --video --speedIndex --pageCompleteCheck "return true;" --resultDir result --connectivity.engine throttle --connectivity.throttle.localhost --connectivity.profile custom --connectivity.latency $LATENCY "$@"
else
    /usr/src/app/bin/browsertime.js -b $BROWSER -n $RUNS --firefox.preference network.dns.forceResolve:127.0.0.1 --video --speedIndex --pageCompleteCheck "return true;" --resultDir result --connectivity.engine throttle --connectivity.throttle.localhost --connectivity.profile custom --connectivity.latency $LATENCY --skipHar --firefox.acceptInsecureCerts "$@"
fi

webpagereplaywrapper replay --stop --path /root/go/src/github.com/catapult-project/catapult/web_page_replay_go --http 80 --https 443

# Send the metrics
bttostatsv result/browsertime.json $GRAPHITE_KEY https://www.wikimedia.org/beacon/statsv
