FROM debian:bullseye
MAINTAINER sebastianmuell

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /app

RUN apt-get -qq update && \
    apt-get install -qqy \
		alsa-utils \
		python3-dev \
		python3-pip \
		python3-venv \
		git && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY sounds/ ./sounds/
RUN git clone https://github.com/rhasspy/wyoming-satellite git-repo && \
	mkdir ./script/ && mv git-repo/script/setup git-repo/script/run ./script/ && \
	mv git-repo/pyproject.toml ./ && \
	mv git-repo/wyoming_satellite ./wyoming_satellite/ && \
	rm -rf git-repo

RUN script/setup
RUN pip install .

EXPOSE 10700

ENTRYPOINT ["/app/script/run"]