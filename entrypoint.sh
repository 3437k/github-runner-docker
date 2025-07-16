#!/bin/bash

# 환경 변수로 GitHub 저장소 정보와 토큰을 받습니다.
# 이 값들은 docker-compose.yml 파일에서 전달됩니다.
GH_OWNER=$GH_OWNER
GH_REPOSITORY=$GH_REPOSITORY
GH_TOKEN=$GH_TOKEN

# GitHub Actions 러너 설정
# /actions-runner/config.sh --url "https://github.com/${GH_OWNER}/${GH_REPOSITORY}" --token "${GH_TOKEN}" --unattended --replace --name "docker-runner-$(hostname)"
./config.sh --url "https://github.com/${GH_OWNER}/${GH_REPOSITORY}" --token "${GH_TOKEN}" --unattended --replace --name "docker-runner-$(hostname)"

# 러너 실행
./run.sh
