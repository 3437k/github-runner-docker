# 베이스 이미지
FROM ubuntu:22.04

# ⭐️ [핵심 수정] rsync와 sudo 패키지 추가 ⭐️
# 시스템 의존성 설치 (root 권한)
RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    openssh-client \
    rsync \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Node.js 설치 (root 권한)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# 일반 사용자 생성 (root 권한)
ARG USERNAME=runner
RUN useradd -m ${USERNAME}
# ⭐️ [핵심 수정] 생성한 사용자에게 비밀번호 없이 sudo 권한 부여 ⭐️
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 러너 디렉토리 변수 정의 및 생성 (root 권한)
ARG RUNNER_DIR=/home/${USERNAME}/actions-runner
RUN mkdir -p ${RUNNER_DIR}

# 스크립트 먼저 복사 및 권한 설정 (root 권한으로 실행)
COPY entrypoint.sh ${RUNNER_DIR}/entrypoint.sh
RUN chmod +x ${RUNNER_DIR}/entrypoint.sh

# 러너 다운로드 및 압축 해제 (root 권한)
ARG RUNNER_VERSION="2.317.0"
ARG RUNNER_ARCH="x64"
RUN curl -o ${RUNNER_DIR}/actions-runner.tar.gz \
         -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ${RUNNER_DIR}/actions-runner.tar.gz -C ${RUNNER_DIR} \
    && rm ${RUNNER_DIR}/actions-runner.tar.gz

# 러너에 필요한 의존성(libicu 등) 설치
RUN ${RUNNER_DIR}/bin/installdependencies.sh

# 모든 파일의 소유권을 'runner' 사용자로 변경 (root 권한)
RUN chown -R ${USERNAME}:${USERNAME} ${RUNNER_DIR}

# 작업 디렉토리 설정
WORKDIR ${RUNNER_DIR}

# 컨테이너의 기본 사용자를 'runner'로 전환
USER ${USERNAME}

# 컨테이너 시작 시 entrypoint.sh 실행
ENTRYPOINT ["./entrypoint.sh"]