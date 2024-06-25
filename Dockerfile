# Ubuntu 20.04 LTS를 기반 이미지로 사용
FROM ubuntu:20.04

# 비대화면(frontend) 환경에서 apt-get을 사용할 때 오류가 나지 않도록 설정
ENV DEBIAN_FRONTEND=noninteractive

# 기본 패키지 설치 및 업데이트
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ca-certificates \
    build-essential \
    zsh \
    vim \
    wget \
    unzip \
    fonts-powerline \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# oh-my-zsh install
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh theme 설정
ENV ZSH_THEME agnoster

# zsh theme setting
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="$ZSH_THEME"/g' ~/.zshrc

# zsh 색상 설정
RUN echo 'export TERM=xterm-256color' >> ~/.zshrc

# zsh 한글 설정
RUN echo 'export LANG=ko_KR.UTF-8' >> ~/.zshrc

# zsh 플러그인 설정
# zsh-syntax-highlighting 설치
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-autosuggestions 설치
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# autojump 설치
# 
# RUN git clone git://github.com/wting/autojump.git
# RUN cd autojump \
#     && ./install.py \
#     && cd .. \
#     && rm -rf autojump


# zsh-completions 설치
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

# 플러그인 활성화
RUN sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)/g' ~/.zshrc

# zshrc 재소스
RUN echo 'source ~/.zshrc' >> ~/.zsh

# nvm 설치
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 20.15.0
RUN mkdir $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | zsh \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# nvm 환경 변수 설정
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
# ------ package manager ------
# pnpm 설치
RUN npm install -g pnpm@9.1.0
