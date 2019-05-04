#!/usr/bin/env bash

imageTests+=(
	[luckydonald/docker-telegram-bot]='
	'
)
testAlias+=(
	[luckydonald/docker-telegram-bot]='python'
)
globalExcludeTests+=(
    ["cve-2014--shellshock"]=1
)
