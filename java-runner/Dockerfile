# Base image
FROM ubuntu:22.04

# [Key Change] Add rsync and sudo packages 
# Install system dependencies (root privileges)
RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    openssh-client \
    rsync \
    sudo \
    wget \  
    gnupg \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Java 21 설치 (Adoptium)
RUN mkdir -p /etc/apt/keyrings && \
    wget -O- https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor > /etc/apt/keyrings/adoptium.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb bookworm main" > /etc/apt/sources.list.d/adoptium.list && \
    apt-get update && apt-get install -y temurin-21-jdk && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js (root privileges)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Create a regular user (root privileges)
ARG USERNAME=runner
RUN useradd -m ${USERNAME}

# [Key Change] Grant sudo privileges to the created user without a password 
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Define and create runner directory (root privileges)
ARG RUNNER_DIR=/home/${USERNAME}/actions-runner
RUN mkdir -p ${RUNNER_DIR}

# Copy script first and set permissions (run with root privileges)
COPY entrypoint.sh ${RUNNER_DIR}/entrypoint.sh
RUN chmod +x ${RUNNER_DIR}/entrypoint.sh

# Download and extract runner (root privileges)
ARG RUNNER_VERSION="2.317.0"
ARG RUNNER_ARCH="x64"
RUN curl -o ${RUNNER_DIR}/actions-runner.tar.gz \
         -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ${RUNNER_DIR}/actions-runner.tar.gz -C ${RUNNER_DIR} \
    && rm ${RUNNER_DIR}/actions-runner.tar.gz

# Install dependencies required by the runner (e.g., libicu)
RUN ${RUNNER_DIR}/bin/installdependencies.sh

# Change ownership of all files to 'runner' user (root privileges)
RUN chown -R ${USERNAME}:${USERNAME} ${RUNNER_DIR}

# Set working directory
WORKDIR ${RUNNER_DIR}

# Switch default user of the container to 'runner'
USER ${USERNAME}

# Execute entrypoint.sh when the container starts
ENTRYPOINT ["./entrypoint.sh"]
