# Git-Hours

[Git-Hours](https://github.com/kimmobrunfeldt/git-hours) is a tool used to estimate time spent on a git repository.

## Usage

Git-Hours [usage](https://github.com/kimmobrunfeldt/git-hours#usage).

## Usage of the Docker image

Mount your working directory as `/var/task` in the Docker container.

In bash:

```bash
docker run --rm --mount "type=bind,source=$(pwd),destination=/var/task" yehorb/git-hours:latest
```

In PowerShell:

```powershell
docker run --rm --mount "type=bind,source=${pwd},destination=/var/task" yehorb/git-hours:latest
```

This command will run plain `git-hours` command. To customize the `git-hours` execution,
use the `git-hours` executable:

```bash
docker run --rm --mount "type=bind,source=$(pwd),destination=/var/task" yehorb/git-hours:latest git-hours -a 180 -d 240
```

## Credits

1. This image is based on official [Node.js](https://hub.docker.com/_/node) images.
2. [git-hours](https://github.com/kimmobrunfeldt/git-hours) by [Kimmo Brunfeldt](https://github.com/kimmobrunfeldt).
