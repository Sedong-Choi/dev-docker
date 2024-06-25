#!/bin/bash

# build.sh 실행 대기
# build.sh 실행 후 성공여부 return 받기
./build.sh

# exit 1 반환시 더이상 실행하지 않음
if [ $? -ne 0 ]; then
    exit 1
fi

# tag 없는 이미지 삭제 명령어
no_tag_images=$(docker images | grep '^<none>' | awk '{print $3}')
if [ -z "$no_tag_images" ]; then
    break;
else
    echo "Removing no tag images --"
    echo "-------------"
    echo "$no_tag_images"
    echo "-------------"
    docker rmi $no_tag_images
fi

# 사용자로부터 컨테이너 이름 입력 받기
echo "Enter container name:"
read container_name

# 사용자로부터 타겟 이미지 입력 받기

# 중복되지 않은 tag list 표시 해주기
echo "Existing images repositories --"
echo "-------------"
docker images | awk '{print $1}' | grep -v 'REPOSITORY' | sort | uniq
echo "-------------"
echo "Enter target repositories:"
read target_repo

# 사용자로부터 타겟 버전 입력 받기
# tag version list 표시하기
echo "Existing images tags --"
docker images | grep "$target_repo" | awk '{print $2}' | sort | uniq
echo "-------------"

echo "Enter target version:"
read target_version

# 입력받은 정보를 사용하여 docker run 명령어 실행
docker run -d -t --name "$container_name" "$target_repo":"$target_version"