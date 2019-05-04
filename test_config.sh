#!/usr/bin/env bash

imageTests+=(
	[luckydonald/docker-telegram-bot]='
	'
)
testAlias+=(
	[luckydonald/docker-telegram-bot]='python'
)
globalTests=(
	utc
	# cve-2014--shellshock
	no-hard-coded-passwords
	override-cmd
)
