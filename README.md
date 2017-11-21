# docker-telegram-bot
A flask based telegram bot docker container.

[![build passing](https://travis-ci.org/luckydonald/docker-telegram-bot.svg?branch=master)](https://travis-ci.org/luckydonald/docker-telegram-bot)




####  How to update the containers

I'll do that, don't worry. But I always forget how to.
That's why I put it here.

###### Mac OS requirements
Gets you a better `sed` and as well as working `sort`. Actually some other great programs are also included, fully for free!
```bash
$ brew install gnu-sed coreutils
$ new_path='PATH="/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/coreutils/libexec/gnubin:$PATH"'
$ echo $new_path >> ~/.bashrc
$ eval $new_path
```

###### Just do it!
Execute the script, and push it to github.
Travis will build containers.
```bash
$ bash update.sh
```
After looking at the updated `Dockerfile`s and the `.travis.yml` let's git gud.
```bash
$ git add -u
$ git commit -m "Updated to latest version"
$ git push
```

