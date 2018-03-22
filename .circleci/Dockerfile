FROM debian

# First install CircleCI tools
RUN apt-get update && apt-get install -y --no-install-recommends \
	git ssh tar gzip ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
	bash make curl node npm \
	md5deep \
	poppler-utils \
	&& rm -rf /var/lib/apt/lists/*
