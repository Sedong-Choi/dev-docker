# Ubuntu 20.04 LTS를 기반 이미지로 사용
FROM ubuntu:20.04

# 기본 패키지 설치 및 업데이트
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    zsh \
    vim \
    unzip \
    sudo \
    language-pack-en \
    fontconfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# To Fix this error : '(anon):12: character not in range'
RUN update-locale

# d2coding font 다운로드 및 설치
RUN curl -LJO https://github.com/naver/d2codingfont/releases/download/VER1.3.2/D2Coding-Ver1.3.2-20180524.zip \
    && mkdir -p /usr/share/fonts/truetype/d2coding \
    && unzip D2Coding-Ver1.3.2-20180524.zip -d /usr/share/fonts/truetype/d2coding \
    && rm -rf D2Coding-Ver1.3.2-20180524.zip \
    && fc-cache -fv

# nvm, Node.js, pnpm 설치
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 20.15.0
RUN mkdir $NVM_DIR \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install -g pnpm@9.1.0



# 개발자 유저 및 그룹 생성
# developers 그룹 생성
RUN groupadd -g 999 developers

# 공통 개발자 유저 생성
# -r: 시스템 계정 생성
# -u: UID 지정
# -g: 그룹 지정
RUN useradd -r -u 999 -g developers -m -d /home/developers developers

# developers group 에 sudo 권한 부여
RUN echo '%developers ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# 개발 환경 디렉토리 생성 및 설정
RUN mkdir -p /developers/workspace && chown -R developers:developers /developers/workspace
WORKDIR /developers/workspace

# developers 사용자로 전환
USER developers

# zsh theme 설정
ENV ZSH_THEME agnoster

# oh-my-zsh, zsh 플러그인 설치 및 설정
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions \
    # theme 변경
    && sed -i "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"$ZSH_THEME\"/g" ~/.zshrc \  
    && sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)/g' ~/.zshrc \
    && echo 'export NVM_DIR="/usr/local/nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm\n[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc