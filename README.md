# docker-telegram-bot
A flask based telegram bot docker container.

[![build passing](https://travis-ci.org/luckydonald/docker-telegram-bot.svg?branch=master)](https://travis-ci.org/luckydonald/docker-telegram-bot)

###### [Docker Hub](https://hub.docker.com/r/luckydonald/telegram-bot/)


#### Image tags

- `python3.6-stretch-port`
- `python3.6-stretch-socket`
- `python3.6-stretch-port-onbuild`
- `python3.6-stretch-socket-onbuild`
- `python3.6.10-stretch-port`
- `python3.6.10-stretch-socket`
- `python3.6.10-stretch-port-onbuild`
- `python3.6.10-stretch-socket-onbuild`
- `python3.7-stretch-port`
- `python3.7-stretch-socket`
- `python3.7-stretch-port-onbuild`
- `python3.7-stretch-socket-onbuild`
- `python3.7.7-stretch-port`
- `python3.7.7-stretch-socket`
- `python3.7.7-stretch-port-onbuild`
- `python3.7.7-stretch-socket-onbuild`
- `python3.8-buster-port`
- `python3.8-buster-socket`
- `python3.8-buster-port-onbuild`
- `python3.8-buster-socket-onbuild`
- `python3.8.2-buster-port`
- `python3.8.2-buster-socket`
- `python3.8.2-buster-port-onbuild`
- `python3.8.2-buster-socket-onbuild`

See https://hub.docker.com/r/luckydonald/telegram-bot/tags for a list of existing image builds.

For version pinning we serve the image with the following tag structure:
- <code>python<i><b>{version}</b></i>-{flavor}-port</code>
    - <code>python<i><b>{version}</b></i>-{flavor}-port-<i><b>{commit}</b></i></code>
    - <code>python<i><b>{version}</b></i>-{flavor}-port-<i><b>{YYYY-MM-DD}</b></i></code>
    - <code>python<i><b>{version}</b></i>-{flavor}-port-<i><b>{YYYY-MM-DD}</b></i>-<i><b>{commit}</b></i></code>
- <code>python<i><b>{version}</b></i>-{flavor}-port-onbuild</code>
    - <code>python<i><b>{version}</b></i>-{flavor}-port-<i><b>{commit}</b></i>-onbuild</code>
    - <code>python<i><b>{version}</b></i>-{flavor}-port-<i><b>{YYYY-MM-DD}</b></i>-onbuild</code>
    - <code>python<i><b>{version}</b></i>-{flavor}-port-<i><b>{YYYY-MM-DD}</b></i>-<i><b>{commit}</b></i>-onbuild</code>
- <code>python<i><b>{version}</b></i>-{flavor}-socket</code>
    - <code>python<i><b>{version}</b></i>-{flavor}-socket-<i><b>{commit}</b></i></code>
    - <code>python<i><b>{version}</b></i>-{flavor}-socket-<i><b>{YYYY-MM-DD}</b></i></code>
    - <code>python<i><b>{version}</b></i>-{flavor}-socket-<i><b>{YYYY-MM-DD}</b></i>-<i><b>{commit}</b></i></code>
- <code>python<i><b>{version}</b></i>-{flavor}-socket-onbuild</code>
    - <code>python<i><b>{version}</b></i>-{flavor}-socket-<i><b>{commit}</b></i>-onbuild</code>
    - <code>python<i><b>{version}</b></i>-{flavor}-socket-<i><b>{YYYY-MM-DD}</b></i>-onbuild</code>
    - <code>python<i><b>{version}</b></i>-{flavor}-socket-<i><b>{YYYY-MM-DD}</b></i>-<i><b>{commit}</b></i>-onbuild</code>

The same with <code>-port</code> instead of <code>-socket</code>

_Need something else? Create an issue!_

#### Environment variables
###### `HEALTHCHECK_URL`:
Which url to call?
Default: `/healthcheck`

###### `SOCKET_PATH` (Only `-socket`):
Allows to overwrite the place where we expect the socket.
Default: `/sockets/bots/${URL_PATH}.sock`

###### `PORT` (Only `-port`):
Allows to overwrite the http port we're listening on.
Default: `8080`


####  How to update the containers

I'll do that, don't worry.
But as I myself always forget how to, I'll write it down anyway:


###### Mac OS requirements
Gets you a better `sed` and as well as working `sort`. Actually some other great programs are also included, fully for free!
```bash
$ brew install gnu-sed coreutils
$ new_path='PATH="/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/coreutils/libexec/gnubin:$PATH"'
$ echo $new_path >> ~/.bashrc
$ eval $new_path
```
###### adding new versions
Those are simply done by creating new folders.
```bash
rm -r python*

mkdir -p python3.{6{,.10},7{,.7}}/stretch/{port,socket}{,/onbuild}
mkdir -p python3.8{,.2}/buster/{port,socket}{,/onbuild}

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
That's it. Wait for Sir Travis to be done.
