#!/bin/bash

# 사용자로부터 컨테이너 이름 입력 받기
echo "Enter container name:"
read container_name

# 사용자로부터 타겟 이미지 입력 받기
echo "Enter target image:"
read target_image

# 사용자로부터 타겟 버전 입력 받기
echo "Enter target version:"
read target_version

# 입력받은 정보를 사용하여 docker run 명령어 실행
docker run -d -t --name "$container_name" "$target_image":"$target_version"