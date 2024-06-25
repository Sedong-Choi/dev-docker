# run.sh 및 build.sh 파일에서 중복되는 코드를 utils.sh 파일로 분리

# docker images repository 추출 함수
function get_repositories(){
    # repository 추출
    repositories=$(docker images | awk '{print $1}' | grep -v 'REPOSITORY' | sort | uniq)
    echo "$repositories"
}

# docker images tags 추출 함수
function get_tags(){
    # tags 추출
    tags=$(docker images | grep $repo | awk '{print $2}' | grep -v 'TAG' | sort | uniq)
    echo "$tags"
}

# repository와 tag를 이용하여 image가 있는지 확인하는 함수
function exists_image(){
    # repository와 tag를 인자로 받음
    repo=$1
    tag=$2
    # docker images로 repository와 tag를 검색하여 있으면 true, 없으면 false 반환
    docker images | grep -q "$repo" | grep -q "$tag"
}

# container_name을 랜덤으로 생성
# 랜덤으로 {human_name}-{n} 형식의 이름을 생성해주는 함수
function generate_random_name() {
    # human_name을 랜덤으로 생성
    words1=$(gshuf -n 1 /usr/share/dict/words)
    words2=$(gshuf -n 1 /usr/share/dict/words)
    # 랜덤 이름 생성
    random_name="$words1-$words2"
    # 랜덤 이름 출력
    echo "$random_name"
}