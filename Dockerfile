FROM ubuntu:22.04

# 安裝 QEMU 模擬器與相關工具
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    qemu-utils \
    curl \
    wget \
    python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /os

# 下載 Ubuntu Server ISO (以 24.04 為例)
RUN wget -O ubuntu.iso https://releases.ubuntu.com/24.04/ubuntu-24.04-live-server-amd64.iso

# 建立一個 20GB 的虛擬硬碟檔
RUN qemu-img create -f qcow2 ubuntu-hd.qcow2 20G

# 下載網頁版終端機 (noVNC 需要另外配置，這裡先用 ttyd 進入後手動啟動)
RUN wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

EXPOSE 10000

# 啟動指令：這會開啟一個可寫入的終端機
# 進去後你需要手動輸入 QEMU 指令來啟動安裝程序
CMD ["ttyd", "-p", "10000", "bash"]
