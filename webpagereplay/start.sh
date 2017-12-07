#!/bin/bash
set -e

google-chrome --version
firefox --version

export MOZ_LOG=timestamp,rotate:200,nsHttp:5,cache2:5,nsSocketTransport:5,nsHostResolver:5
export MOZ_LOG_FILE=/browsertime/log.txt

RUNS="${RUNS:-5}"
LATENCY=${LATENCY:-100}

webpagereplaywrapper record --start --path /root/go/src/github.com/catapult-project/catapult/web_page_replay_go --http 80 --https 443

/usr/src/app/bin/browsertime.js --firefox.preference network.dns.forceResolve:127.0.0.1 -b firefox --firefox.acceptInsecureCerts -n 1 --pageCompleteCheck "return true;" --skipHar "$@"

webpagereplaywrapper record --stop --path /root/go/src/github.com/catapult-project/catapult/web_page_replay_go

webpagereplaywrapper replay --start --path /root/go/src/github.com/catapult-project/catapult/web_page_replay_go --http 80 --https 443

/usr/src/app/bin/browsertime.js --firefox.preference network.dns.forceResolve:127.0.0.1 -n $RUNS --video --speedIndex --firefox.acceptInsecureCerts --pageCompleteCheck "return true;" --connectivity.engine throttle --connectivity.throttle.localhost --connectivity.profile custom --connectivity.latency $LATENCY --skipHar "$@"

webpagereplaywrapper replay --stop --path /root/go/src/github.com/catapult-project/catapult/web_page_replay_go
