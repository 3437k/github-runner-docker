# GitHub Actions Runner with Docker

This project allows you to run a self-hosted GitHub Actions runner using Docker and Docker Compose.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Included Components

The Docker image is built on Ubuntu 22.04 and includes the following:

-   **Base OS:** Ubuntu 22.04
-   **System Dependencies:** `curl`, `git`, `jq`, `openssh-client`, `rsync`, `sudo`
-   **Node.js:** v18.x
-   **GitHub Actions Runner**
-   **Runner Dependencies:** (e.g., `libicu` and others installed by `installdependencies.sh`)

## Setup

1.  **Clone or download this repository.**

2.  **Configure `docker-compose.yml`:**

    Open the `docker-compose.yml` file and replace the placeholder values for `GH_OWNER` and `GH_REPOSITORY`.

    ```yaml
    services:
      actions-runner:
        build: .
        container_name: my-actions-runner
        environment:
          - GH_OWNER: <Your_GitHub_Username_or_Organization> # <-- EDIT THIS
          - GH_REPOSITORY: <Your_Repository_Name>            # <-- EDIT THIS
          - GH_TOKEN: ${GH_TOKEN}
        restart: always
    ```

3.  **Set your GitHub Personal Access Token (PAT):**

    You need to create a [Personal Access Token](https://github.com/settings/tokens) with the `repo` scope.

    Then, set it as an environment variable named `GH_TOKEN` in your terminal. This variable will be passed to the Docker container.

    **For PowerShell (Windows):**
    ```powershell
    $env:GH_TOKEN = "<your_github_token>"
    ```

    **For bash/zsh (Linux/macOS):**
    ```bash
    export GH_TOKEN="<your_github_token>"
    ```
    > **Note:** The environment variable is only set for the current terminal session. For a more permanent solution, consider using a `.env` file or adding it to your shell's profile.

## Running the Runner

Once you have configured your `docker-compose.yml` and set the `GH_TOKEN` environment variable, you can start the runner with the following command:

```bash
docker-compose up -d --build
```

This command will build the Docker image and start the container in detached mode.

## Verifying the Runner

Go to your GitHub repository's **Settings > Actions > Runners**. You should see your new self-hosted runner listed there with an "Idle" status.

## Managing the Runner

### Stopping the Runner
To stop the container without removing it:
```bash
docker-compose stop
```

### Stopping and Removing the Runner
To stop and remove the container, run:
```bash
docker-compose down
```

### Checking Logs
To view the runner's logs in real-time:
```bash
docker-compose logs -f
```

### Accessing the Container
To open a bash shell inside the running container for debugging:
```bash
docker exec -it my-actions-runner bash
```



