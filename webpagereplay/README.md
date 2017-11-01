

docker build -t browsertime/webpagereplay .
docker run --cap-add=NET_ADMIN --shm-size=1g --rm -v "$(pwd)":/browsertime -e RUNS=11 -e LATENCY=100 browsertime/webpagereplay https://en.wikipedia.org/wiki/Barack_Obama
