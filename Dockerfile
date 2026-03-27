# 使用 Ubuntu 22.04 作為基礎 
FROM ubuntu:22.04

# 設定非互動模式
ENV DEBIAN_FRONTEND=noninteractive

# 確保系統基礎組件是最新的
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    vim \
    nano \
    sudo \
    zip \
    unzip \
    build-essential \
    net-tools \
    iputils-ping \
    dnsutils \
    iproute2 \
    # 確保安裝最新版 python3 與 pip
    python3-full \
    python3-pip \
    python3-venv \
    openjdk-17-jdk \
    g++ \
    make \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# 2026 年 Node.js 安裝優化 (改用官方推薦的直接來源)
# 確保抓取到 Node.js 20.x 的最新 Patch 版本
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install nodejs -y && \
    rm -rf /var/lib/apt/lists/*

# 建立使用者與設定 (同前)
RUN useradd -m -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER user
WORKDIR /home/user

# 安裝 ttyd 並啟動
RUN sudo wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 && \
    sudo chmod +x /usr/local/bin/ttyd

EXPOSE 10000

CMD ["ttyd", "-W", "-p", "10000", "bash"]
