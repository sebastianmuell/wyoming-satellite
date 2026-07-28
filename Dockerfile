FROM debian:trixie

ENV DEBIAN_FRONTEND noninteractive
ENV VENV=/usr/local/venv
ENV PATH="$VENV/bin:$PATH"

WORKDIR /app

RUN apt-get update -qqy && apt-get dist-upgrade -qqy && apt-get install -qqy \
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

# Set up python venv, install wyoming_satellite
RUN mkdir -p $VENV && python3 -m venv --system-site-packages $VENV && \
    python3 -m pip install -U pip wheel setuptools --no-cache-dir && \
	script/setup && python3 -m pip install .

EXPOSE 10700

ENTRYPOINT ["/app/script/run"]