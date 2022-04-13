[![Docker Pulls](https://img.shields.io/docker/pulls/yehorb/git-hours-docker.svg)](https://hub.docker.com/r/yehorb/git-hours-docker/) [![](https://images.microbadger.com/badges/image/yehorb/git-hours-docker.svg)](https://microbadger.com/images/yehorb/git-hours-docker "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/yehorb/git-hours-docker.svg)](https://microbadger.com/images/yehorb/git-hours-docker "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/yehorb/git-hours-docker.svg)](https://microbadger.com/images/yehorb/git-hours-docker "Get your own commit badge on microbadger.com")


# Git-Hours

I created this docker image because I didnt like the size of the [original docker image](http://hub.docker.com/r/khor/git-hours) 
which is based on ubuntu *755MB*, This image is only *168MB*.

_PS_: Am going to copy the commands from the original repository [git-hours](https://github.com/kimmobrunfeldt/git-hours).

## Usage

In root of a git repository run:

    $ git hours

**Note: repository is not detected if you are not in the root of repository!**

Help

```
    Usage: git hours [options]

    Options:

      -h, --help                                 output usage information
      -V, --version                              output the version number
      -d, --max-commit-diff [max-commit-diff]    maximum difference in minutes between commits counted to one session. Default: 120
      -a, --first-commit-add [first-commit-add]  how many minutes first commit of session should add to total. Default: 120
      -s, --since [since-certain-date]           Analyze data since certain date. [always|yesterday|tonight|lastweek|yyyy-mm-dd] Default: always'
      -e, --email [emailOther=emailMain]         Group person by email address. Default: none
      -u, --until [until-certain-date]           Analyze data until certain date. [always|yesterday|today|lastweek|thisweek|yyyy-mm-dd] Default: always
      -m, --merge-request [false|true]           Include merge requests into calculation.  Default: true
      -p, --path [git-repo]                      Git repository to analyze. Default: .
      -b, --branch [branch-name]                 Analyze only data on the specified branch. Default: all branches

    Examples:

     - Estimate hours of project

         $ git hours

     - Estimate hours in repository where developers commit more seldom: they might have 4h(240min) pause between commits

         $ git hours --max-commit-diff 240

     - Estimate hours in repository where developer works 5 hours before first commit in day

         $ git hours --first-commit-add 300

     - Estimate hours work in repository since yesterday

       $ git hours --since yesterday

     - Estimate hours work in repository since 2015-01-31

       $ git hours --since 2015-01-31
       
    - Estimate hours work in repository on the "master" branch

       $ git hours --branch master

    For more details, visit https://github.com/kimmobrunfeldt/git-hours
```

## Run with docker

Install [docker](http://www.docker.com/) and run the following command inside the git repo you want to analyze:

```
docker run --rm -v $(pwd):/code yehorb/git-hours
```

It mounts the current directory (pwd) inside the docker container and runs `git hours` on it.


## Credits

1. This image is based on [official node](https://hub.docker.com/_/node) images.
2. [git-hours](https://github.com/kimmobrunfeldt/git-hours) was built by [Kimmo Brunfeldt](https://github.com/kimmobrunfeldt).
