# README

## Quick start

```bash
$ git clone https://github.com/Sedong-Choi/dev-docker.git

$ bash run.sh

```
### run.sh

[build.sh](./build.sh)를 실행시키며 간단하게 docker Repository 및 Tag 설정을 할 수 있습니다.(상호작용 부분 보완필요)

만약 빌드가 실패하면 script는 중단됩니다.

[run.sh](./run.sh) build가 완료된 이미지를 선택하여 docker를 실행 할 수 있습니다.(상호작용 부분 보완필요)

### addUser.sh (개발 필요)

실행중이거나 이미지 빌드가 완료된 컨테이너에 대하여 유저를 생성하고 zsh 설정을 추가하는 스크립트 입니다.


## 개발환경 설정 기록

Macbook M3 pro 14인치 모델을 사용하고 있으며, 개발환경을 설정하는 과정을 기록한다.

docker container 내부에서 개발환경을 구성하기 위하여 Docker desktop을 사용한다.

#### 1. Docker Desktop 설치

OS에 따른 dependency를 줄이기 위해 Docker를 사용하여 개발환경을 구성하기 위하여 Docker Desktop을 설치한다.

- [Docker Desktop for Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac)에서 다운로드 후 설치한다.

### 2. Docker Desktop 설정

기본설정을 유지하였다.

### 3. VSCode 설치

- [Visual Studio Code](https://code.visualstudio.com/)에서 다운로드 후 설치한다.

### 4. VSCode 설정 및 extendion 설치

기본적으로 docker container를 사용하여 개발환경을 구성하기 위하여 다음과 같은 extension을 설치한다.

macbook에 설치한 extension은 다음과 같다.
최소한의 extension만 설치하였다.

- Docker
- Remote - Containers
- git Graph
- GitHub Copilot **이번에 처음 써본다**

실제 개발에서 사용할 extension은 container내부에서 설치하기로 했다.

### 4.1 Dev container extension

- 

### 4.1 Dockerfile 작성시 고려한 사항

Web 개발을 위하여 Node.js를 사용하고, nvm을 사용하여 Node.js 버전을 관리하였다.


OS 
 - Ubuntu 20.04 LTS : 안정적인 버전을 사용하기 위하여 선택하였다.

root권한은 최소한으로 하여 사용하기 위하여 
그룹과 유저를 생성하였다. (developers)
developers 그룹 내부에 사용자를 추가 하여 사용할 예정이다.

- 유저 분리 이점 : root권한에 대한 접근을 막고, 배포환경에서 사용자를 분리하여 사용하기 위하여
- 그룹 생성 이점 : 사용자를 그룹으로 묶어서 권한을 관리하기 위하여


포트폴리오에 turborepo 사용을 위하여 pnpm 패키지 매니저를 사용하였다.

package manager : pnpm (9.1.0), npm (v10.7.0) 
nvm : v0.39.1
node : v20.15.0


기본 apt packages 

- sudo : docker 사용시 root사용자로 접속하지 않기 위하여
- curl, wget : http 통신을 위하여
- unzip : 각종 압축파일을 풀기 위하여
- git : 소스코드를 관리하기 위하여
- vim : termianl 환경에서 편집을 위하여


추가 apt packages

- zsh : oh-my-zsh 사용을 위하여
- language-pack-en : oh-my-zsh theme사용시 오류를 방지하기 위하여
- fontconfig : font 다운로드 후 caching 위하여 (D2Coding or Powerline)
- 

zsh plugins
 - zsh-syntax-highlighting
 - zsh-autosuggestions
 - zsh-completions

### 5. Dockerfile 작성

[Docker image](https://github.com/Sedong-Choi/dev-docker/blob/main/Dockerfile#L2) - Docker 이미지를 생성하는 데 사용되는 Dockerfile입니다.

[Install package](https://github.com/Sedong-Choi/dev-docker/blob/main/Dockerfile#L5) - 필요한 패키지를 설치하는 단계입니다.

[oh-my-zsh font error fix](https://github.com/Sedong-Choi/dev-docker/blob/main/Dockerfile#L19) - oh-my-zsh 테마를 사용할 때 발생하는 폰트 오류를 수정하는 단계입니다.

[Install font](https://github.com/Sedong-Choi/dev-docker/blob/main/Dockerfile#L22) - 폰트를 설치하는 단계입니다.

[Install nvm](https://github.com/Sedong-Choi/dev-docker/blob/main/Dockerfile#L29) - nvm을 설치하는 단계입니다.

[Add developers group](https://github.com/Sedong-Choi/dev-docker/blob/main/Dockerfile#L43) - "developers" 그룹을 추가하는 단계입니다.

[Include sudo privileges](https://github.com/Sedong-Choi/dev-docker/blob/main/Dockerfile#L52) - sudo 권한을 포함하는 단계입니다.

[Setting for oh-my-zsh](https://github.com/Sedong-Choi/dev-docker/blob/main/Dockerfile#L62) - oh-my-zsh 설치 및 plugin 설정하는 단계입니다.




