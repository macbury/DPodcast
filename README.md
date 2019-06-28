# DPodcast

This service downloads youtube channels videos, convert them into mp3 and host them as normal podcast.

## Requirements

- [ipfs node](https://sh.macbury.ninja/ipns/ipfs.io/)
- [redis](https://redis.io/)
- [docker](https://www.docker.com/)

## Runing in dev

```bash
pip3 install -r requirements.txt 
bundle install
cp .env.example .env
mkdir -p data/
```

Create `data/feeds.yml` with list of channel ids or videos from which extract channel id:

```yaml
channels:
  - UCfpnY5NnBl-8L7SvICuYkYQ
  - UCe02lGcO-ahAURWuxAJnjdA
videos:
  - Cff9Lwg0eaE
  - Eaq6kbk0LZ4
  - uicB1MghgJs
  - HQ52yUCbvvY
  - aUL8cz4B6Sk
```

Run sidekiq workers

```bash
bin/workers
```

Run sidekiq web panel
```bash
bin/server
```

## Generate ipns key

After generating key save it to `.env`

```
ipfs key gen --type=rsa --size=2048 podcasts
ipfs name publish --key=podcasts /ipfs/QmYFXebR1zoPKk1zPhTFSha3uksXpTrY8qZVzdoQG3PZFm --quieter
```

## Deploy

```bash
docker build . -t dpodcast
docker tag dpodcast macbury/dpodcast:latest
docker push macbury/dpodcast:latest
```