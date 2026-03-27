FROM ubuntu:22.04
RUN apt-get update && apt-get install -y sudo curl wget git python3 nodejs npm && rm -rf /var/lib/apt/lists/*
RUN useradd -m -s /bin/bash user && echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER user
WORKDIR /home/user
RUN sudo wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 && sudo chmod +x /usr/local/bin/ttyd
EXPOSE 10000
CMD ["ttyd", "-W", "-p", "10000", "bash"]
