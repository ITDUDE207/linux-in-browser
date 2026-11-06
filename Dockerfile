FROM ubuntu:24.04

ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=10000
ENV HOME=/home/sandbox
ENV PATH="/usr/local/bin:${PATH}"

# Install Linux programming tools
RUN apt-get update && apt-get install -y \
    bash \
    ca-certificates \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    nodejs \
    npm \
    build-essential \
    make \
    gcc \
    g++ \
    vim \
    nano \
    less \
    procps \
    iputils-ping \
    dnsutils \
    unzip \
    zip \
    tar \
    jq \
    tree \
    file \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Download and verify ttyd
RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) \
        TTYD_ARCH="x86_64"; \
        TTYD_SHA="8a217c968aba172e0dbf3f34447218dc015bc4d5e59bf51db2f2cd12b7be4f55" ;; \
      arm64) \
        TTYD_ARCH="aarch64"; \
        TTYD_SHA="b38acadd89d1d396a0f5649aa52c539edbad07f4bc7348b27b4f4b7219dd4165" ;; \
      *) echo "Unsupported architecture: $TARGETARCH"; exit 1 ;; \
    esac; \
    curl -fsSL \
      "https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.${TTYD_ARCH}" \
      -o /usr/local/bin/ttyd; \
    echo "${TTYD_SHA}  /usr/local/bin/ttyd" | sha256sum -c -; \
    chmod +x /usr/local/bin/ttyd

# Create an unprivileged Linux user
RUN useradd -m -s /bin/bash sandbox \
    && mkdir -p /home/sandbox/workspace \
    && chown -R sandbox:sandbox /home/sandbox

COPY start.sh /start.sh
RUN chmod 755 /start.sh

USER sandbox
WORKDIR /home/sandbox/workspace

EXPOSE 10000

CMD ["/start.sh"]
