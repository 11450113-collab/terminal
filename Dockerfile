# 使用 Ubuntu 22.04 作為基底系統 [cite: 3]
FROM ubuntu:22.04

# 設定非互動模式，避免安裝過程卡住 [cite: 3]
ENV DEBIAN_FRONTEND=noninteractive

# 1. 安裝常用工具 (curl, git, vim 等) [cite: 3]
# 2. 下載 ttyd (這是核心工具) [cite: 3]
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    sudo \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/* \
    && wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    && chmod +x /usr/local/bin/ttyd

# 建立一個名叫 'user' 的使用者，並給予 sudo 權限 (免密碼) [cite: 3, 4]
RUN useradd -m -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nopasswd [cite: 4]

# 切換到該使用者
USER user
WORKDIR /home/user

# Render 建議使用的 Port (通常為 10000)
EXPOSE 10000

# 啟動 ttyd [cite: 4]
# -W: 允許寫入 (可以輸入指令) [cite: 4]
# -p 10000: 指定為 Render 慣用的 Port
# bash: 執行的 Shell [cite: 4]
CMD ["ttyd", "-W", "-p", "10000", "bash"]