#!/bin/bash
set -e

google-chrome --version
firefox --version


RUNS="${RUNS:-5}"
LATENCY=${LATENCY:-100}
BROWSER=${BROWSER:-'chrome'}

CHROME_EXTRAS='--chrome.args host-resolver-rules="MAP *:80 127.0.0.1:80,MAP *:443 127.0.0.1:443,EXCLUDE localhost"'
FIREFOX_EXTRAS='--firefox.preference "network.dns.forceResolve:127.0.0.1"'

EXTRAS=''

if [ $BROWSER = 'chrome' ]
then
  EXTRAS=$CHROME_EXTRAS
else
  EXTRAS=$FIREFOX_EXTRAS
fi

webpagereplaywrapper record --start --path /root/go/src/github.com/catapult-project/catapult/web_page_replay_go --http 80 --https 443


/usr/src/app/bin/browsertime.js -b $BROWSER -n 1 "$EXTRAS" --pageCompleteCheck "return true;" "$@"

webpagereplaywrapper record --stop --path /root/go/src/github.com/catapult-project/catapult/web_page_replay_go --http 80 --https 443

webpagereplaywrapper replay --start --path /root/go/src/github.com/catapult-project/catapult/web_page_replay_go --http 80 --https 443


/usr/src/app/bin/browsertime.js -b $BROWSER -n $RUNS "$EXTRAS" --video --speedIndex --pageCompleteCheck "return true;" --connectivity.engine throttle --connectivity.throttle.localhost --connectivity.profile custom --connectivity.latency $LATENCY "$@"

webpagereplaywrapper replay --stop --path /root/go/src/github.com/catapult-project/catapult/web_page_replay_go --http 80 --https 443
