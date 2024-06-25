#!/bin/bash

# 마지막에 build시 사용된 command를 저장할 변수
command="docker buildx build"

echo "Existing Repository --"
echo "-------------"
docker images | awk '{print $1}' | grep -v 'REPOSITORY' | sort | uniq
echo "-------------"
echo "Enter target repository:"
read repo

echo "Selected repository: $repo"

# tags 추출
echo "Existing tags --"
tags=$(docker images | grep $repo | awk '{print $2}' | grep -v 'TAG' | sort | uniq)
echo "-------------"
# tag 순차적으로 표시
echo "$tags"
echo "-------------"
echo "Enter new tag (or press enter to keep last tag)"

# tags의 가장 마지막 tag를 tag 변수에 할당
read tag
if [ -z "$tag" ]; then
    tag=$(echo $tags | awk '{print $NF}')
fi

echo "Selected tag: $tag"

# cache 사용할 것인가 확인

echo "Use cache? (y/n)"
read use_cache

if [ "$use_cache" == "y" ]; then
    command="$command -t $repo:$tag ."
else
    command="$command --no-cache -t $repo:$tag ."
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
