# Wyoming Satellite

Wyoming Satellite for streaming audio and interacting with assist.

## Build
Sounds are not included - place the wav files in ./sounds/ dir.
docker build -t wyoming-satellite .

## Usage
docker run -d --restart=on-failure \
  --name=wyoming-satellite-oww \
  --network=host \
  --group-add=audio \
  --security-opt seccomp=unconfined rhasspy/wyoming-openwakeword \
  --uri 'tcp://127.0.0.1:10400' \
  --preload-model 'alexa'
  
docker run -d --restart=on-failure \
  --name=wyoming-satellite \
  --network=host \
  --device=/dev/snd \
  --group-add=audio \
  --security-opt seccomp=unconfined wyoming-satellite \
  --name 'audio-satellite' \
  --mic-command 'arecord -D plughw:0,0 -r 16000 -c 1 -f S16_LE -t raw' \
  --snd-command 'aplay -D plughw:0,0 -r 22050 -c 1 -f S16_LE -t raw' \
  --uri 'tcp://0.0.0.0:10700' \
  --wake-uri 'tcp://127.0.0.1:10400' \
  --awake-wav '/app/sounds/awake.wav' --done-wav '/app/sounds/done.wav' --timer-finished-wav '/app/sounds/timer_finished.wav' \
  --wake-word-name 'alexa'

## Contributing
Always welcome.

## Authors and acknowledgment
rhasspy - for maintaining and developing wyoming-openwakeword and wyoming-satellite 

## License
This repository contains **custom configurations** (Dockerfile, docker-compose.yml, and GitLab CI files) licensed under **GPLv3**.

As with all Docker images, this image is built on top of other software that may be under different licenses:

- The **base Debian image** (`debian:bullseye`) includes software under various licenses (e.g., GPL, BSD, MIT).
- The **`rhasspy/wyoming-satellite`** project is included as a dependency and is subject to its own license (check its repository for details).
- The **`rhasspy/wyoming-openwakeword`** image is included as a dependency and is subject to its own license (check its repository for details).

**As with any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with all relevant licenses for the software contained within.**

## Project status
Not actively maintained.
