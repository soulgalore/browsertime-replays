# Browsertime + WebPageReplay
Use Browsertime and WebPageReplay together.

The current version only works for Chrome. To get it to work for Firefox we need to install the CA and have host-resolver-rules for Firefox.

It works like this:
1. The start script starts WebPageReplay in record mode
2. Then starts Browsertime accessing the URL you choose one time (so it is recorded)
3. WebPageReplay is closed down
4. WebPageReplay in replay mode is started
5. Browsertime access the URL so many times you choose.


## Build

```
docker build -t soulgalore/browsertime-webpagereplay .
```

## Run
You can change the latency and number of runs with LATENCY and RUNS.

```
docker run --cap-add=NET_ADMIN --shm-size=1g --rm -v "$(pwd)":/browsertime -e RUNS=11 -e LATENCY=100 soulgalore/browsertime-webpagereplay https://en.wikipedia.org/wiki/Barack_Obama
```
