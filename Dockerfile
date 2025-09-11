FROM debian:latest
ENV DEBIAN_FRONTEND=noninteractive

# 更换为中科大源
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources

# 安装必要的软件包
RUN apt-get update && apt-get install -y \
    openssh-server \
    python3 \
    unzip \
    curl \
    git \
    vim \
    sudo \
    screen \
    zsh \
    fzf \
    build-essential \
    && rm -rf /var/lib/apt/lists/*


# 创建SSH目录
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh
RUN mkdir -p /opt
# 配置SSH服务
RUN mkdir /var/run/sshd
RUN git config --global url."https://gh-proxy.com/https://github.com/".insteadOf https://github.com/
# 配置SSH安全设置：禁用密码登录，仅允许密钥认证
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
# zoxide
RUN curl -sSfL https://gh-proxy.com/https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
# uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

RUN repo="sxyazi/yazi" && asset="x86_64-unknown-linux-musl.zip" \
    && url=$(curl -s https://api.github.com/repos/$repo/releases/latest \
    | grep "browser_download_url" \
    | grep "$asset" \
    | cut -d '"' -f 4) \
    && curl -L -o /tmp/yazi.zip "https://gh-proxy.com/${url}" \
    && unzip -o /tmp/yazi.zip -d /opt \
    && rm /tmp/yazi.zip

RUN ln -sf /opt/yazi-x86_64-unknown-linux-musl/yazi /usr/local/bin/yazi

RUN mkdir -p /usr/share/zsh/site-functions \
    && cp /opt/yazi-x86_64-unknown-linux-musl/completions/_yazi /usr/share/zsh/site-functions/


RUN chsh -s /bin/zsh

# 暴露SSH端口
EXPOSE 22

# 启动SSH服务
CMD ["/usr/sbin/sshd", "-D"]