# Browsertime + WebPageReplay
Use Browsertime and WebPageReplay together.

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
You can change browser, latency and number of runs with BROWSER, LATENCY and RUNS.

Default browser is Chrome:

```
docker run --cap-add=NET_ADMIN --shm-size=1g --rm -v "$(pwd)":/browsertime -e RUNS=11 -e LATENCY=100 soulgalore/browsertime-webpagereplay https://en.wikipedia.org/wiki/Barack_Obama
```

Use Firefox (note that we need to skipHar until there's a new Firefox plugin for 57):

```
docker run --cap-add=NET_ADMIN --shm-size=1g --rm -v "$(pwd)":/browsertime -e BROWSER=firefox -e RUNS=11 -e LATENCY=100 soulgalore/browsertime-webpagereplay https://en.wikipedia.org/wiki/Barack_Obama --skipHar --firefox.acceptInsecureCerts
```