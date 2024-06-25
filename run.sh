#!/bin/bash

# utils.sh 파일을 source 명령어로 실행
source ./utils.sh


# tag 없는 이미지 삭제 명령어
no_tag_images=$(docker images | grep '^<none>' | awk '{print $3}')
if [ -n "$no_tag_images" ]; then
    echo "Removing no tag images..."
    docker rmi $no_tag_images
fi

# repository 추출

repositories=$(get_repositories)

if [ -z "$repositories" ]; then
    # repository가 없는 경우 build.sh 실행
    if [ -f "build.sh" ]; then
        # build.sh 파일이 있는 경우 실행
        wait bash build.sh
        # build.sh 파일이 실행되는 동안 대기
        # build.sh 파일이 실행되면 repository가 생성됨
    else
        # build.sh 파일이 없는 경우 에러 메시지 출력
        echo "build.sh file not found. Aborting."
        # Add any additional error handling code here if needed
    fi
fi
# repositories 재추출
repositories=$(get_repositories)

echo "Existing Repositories"
echo "-------------"
# repository가 있는 경우
# 한 줄씩 출력
echo "$repositories"
echo "-------------"

echo "Enter target repositories:"
read target_repo


# 입력받은 target_repo가 repositories 내부에 없는 경우 while문 반복
# empty value가 들어와도 while문 반복
while [ -z "$target_repo" ] || ! echo "$repositories" | grep -q "$target_repo"; do
    # repositories에 없는 target_repo 입력시 에러 메시지 출력
    echo "Repository not found. Please enter a valid repository."
    echo "-------------"
    echo "$repositories"
    echo "-------------"
    read target_repo
done
echo "Selected repository: $target_repo"

# tags 추출
tags=$(docker images | grep "$target_repo" | awk '{print $2}' | sort | uniq)

# tags는 항상 존재

# tag version list 표시하기
echo "Existing image tags"
echo "-------------"
echo "$tags"
echo "-------------"
echo "Enter target tags(or enter empty value to select last tag):"
read target_tag

# 입력받은 tag가 없는 경우
if [ -z "$target_tag" ]; then
    # tags의 가장 마지막 tag를 target_tag에 할당
    target_tag=$(echo "$tags" | tail -n 1)
fi

echo "Selected tag: $target_tag"

# 사용자로부터 컨테이너 이름 입력 받기
echo "Enter container name(or enter empty value to generate random name):"
read container_name

# 입력받은 컨테이너 이름이 없는 경우
if [ -z "$container_name" ]; then
    # 랜덤으로 이름 생성
    container_name=$(generate_random_name)
    echo "Generated container name: $container_name"
else
    echo "Selected container name: $container_name"
fi
# 입력받은 정보를 사용하여 docker run 명령어 실행
docker run -d -t --name "$container_name" "$target_repo":"$target_tag"

