#!/bin/bash

# utils.sh 파일을 source 명령어로 실행
source ./utils.sh

# 마지막에 build시 사용된 command를 저장할 변수
command="docker buildx build"


# repository 추출
repositories=$(get_repositories)

# repository가 없는 경우
if [ -z "$repositories" ]; then
    echo "No existing repositories."
    echo "Create a new repository."
else
    echo "Existing Repositories"
    echo "-------------"
    # repository가 있는 경우
    # 한 줄씩 출력
    echo "$repositories"
    echo "-------------"
fi

echo "Enter target repository(if enter empty value, create example-{n} repository):"
read repo
# enter 입력시 Random으로 생성

if [ -z "$repo" ]; then
    # exmpale-1, example-2, example-3, ...
    # 순서대로 생성
    repo="example-$(($(echo "$repositories" | grep -c "$repo") + 1))"
    echo "Generated repository: $repo"
else
    echo "Selected repository: $repo"
fi

# tags 추출
tags=$(get_tags)

# tags가 있는 경우
if [ -n "$tags" ]; then
    echo "Existing tags --"
    # 한 줄씩 출력
    echo "-------------"
    # tag 순차적으로 표시
    echo "$tags"
    echo "-------------"
    # minor 버전을 1씩 증가시킨다.
    # major 버전은 그대로 유지
    # ex) 0.1 -> 0.2
    # ex) 1.0 -> 1.1
    echo "Enter target tag(or enter empty value to increment minor version):"
    read tag
fi

# tags의 가장 마지막 tag를 tag 변수에 할당
if [ -z "$tag" ]; then
    # tags가 없는 경우 0.1로 설정
    if [ -z "$tags" ]; then
        # 0.1로 설정
        echo "No existing tags. Setting tag to 0.1"
        tag="0.1"
    else
        # 마지막 태그를 추출하고 0.1을 더함
        last_tag=$(echo "$tags" | sort -V | tail -n1)
        major=$(echo "$last_tag" | cut -d. -f1)
        minor=$(echo "$last_tag" | cut -d. -f2)
        minor=$(echo "$minor + 1" | bc)
        tag="$major.$minor"
    fi
fi

echo "Selected tag: $tag"

# cache 사용할 것인가 확인

echo "Use cache? (y/n)"
read use_cache

# enter 입력시 y로 처리
if [ -z "$use_cache" ]; then
    use_cache="y"
fi

# cache 사용 여부에 따라 command 변경
if [ "$use_cache" == "y" ]; then
    command="$command -t $repo:$tag ."
else
    command="$command --no-cache -t $repo:$tag ."
fi

# build 전에 동일한 tag가 있는지 확인
# 조건을 exists_image 함수로 분리
# 이미지가 있는 경우 0을 리턴
# 이미지가 없는 경우 1을 리턴
if [ "$(exists_image $repo $tag)" == "0" ]; then
    echo "Tag $tag already exists. Overwrite? (y/n)"
    read overwrite
    if [ "$overwrite" != "y" ]; then
        echo "Exiting."
        echo "Skipping build."
        exit 1
    fi
fi

if [ -n "$(docker images | grep $repo | grep $tag)" ]; then
    echo "$repo:$tag already exists. Overwrite? (y/n)"
    read overwrite
    if [ "$overwrite" != "y" ]; then
        echo "Exiting."
        echo "Skipping build."
        exit 1
    fi
fi

# start build 
echo "Start build"
echo "-------------"
echo "Command: $command"
echo "-------------"
$command





while [ $? -ne 0 ]; do
    echo "Build failed."
    echo "-------------"
    # command 실패시 false 반환
    exit 1
done
