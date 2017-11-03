# Browsertime + mahimahi
Use Browsertime and mahimahi (patched Benedikt and Gilles version) together.

At the moment running this doesn't work.

## Build

```
docker build -t browsertime/mahimahi .
```

## Run

``
docker run --privileged --cap-add=NET_ADMIN --shm-size=1g --rm -v "$(pwd)":/browsertime browsertime/mahimahi
```

