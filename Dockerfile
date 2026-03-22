# 使用 Ubuntu 22.04 作為基礎 
FROM ubuntu:22.04

# 設定非互動模式 
ENV DEBIAN_FRONTEND=noninteractive

# 一次性安裝所有常用開發套件 (pkg)
RUN apt-get update && apt-get install -y \
    # 1. 基礎系統工具 
    curl \
    wget \
    git \
    vim \
    nano \
    sudo \
    zip \
    unzip \
    build-essential \
    # 2. 網路診斷工具 
    net-tools \
    iputils-ping \
    dnsutils \
    iproute2 \
    # 3. 程式語言環境 (Python, Java, C++)
    python3 \
    python3-pip \
    python3-venv \
    openjdk-17-jdk \
    g++ \
    make \
    # 4. Node.js 官方 LTS 腳本安裝流程 [cite: 3, 4]
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    # 5. 清理快取以縮減映像檔體積
    && rm -rf /var/lib/apt/lists/* \
    # 6. 安裝 ttyd 終端機工具 
    && wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    && chmod +x /usr/local/bin/ttyd

# 建立使用者 'user' 並設定工作目錄 [cite: 3, 4]
RUN useradd -m -s /bin/bash user
USER user
WORKDIR /home/user

# Render 預設 Port 10000 [cite: 3, 4]
EXPOSE 10000

# 啟動 ttyd 終端機 [cite: 4]
CMD ["ttyd", "-W", "-p", "10000", "bash"]