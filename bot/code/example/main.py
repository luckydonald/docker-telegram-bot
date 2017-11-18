# -*- coding: utf-8 -*-
__author__ = 'luckydonald'

import os
from flask import Flask, url_for
from teleflask import Teleflask
from teleflask.messages import HTMLMessage, MarkdownMessage, TextMessage
from luckydonaldUtils.logger import logging

API_KEY = os.getenv('TG_API_KEY', None)
assert(API_KEY is not None)  # TG_API_KEY environment variable

URL_HOSTNAME = os.getenv('URL_HOSTNAME', None)
# URL_HOSTNAME environment variable, can be None

URL_PATH = os.getenv('URL_PATH', None)
assert(URL_PATH is not None)  # URL_PATH environment variable


logger = logging.getLogger(__name__)
logging.add_colored_handler(level=logging.DEBUG)

app = Flask(__name__)

bot = Teleflask(API_KEY, hostname=URL_HOSTNAME, hostpath=URL_PATH, hookpath="/income/{API_KEY}")
bot.init_app(app)


@app.errorhandler(404)
def url_404(error):
    return "404.", 404
# end def


@app.route("/", methods=["GET","POST"])
def url_root():
    return '<b>Hello world</b> from your <a href="https://github.com/luckydonald/docker-telegram-bot/">flask based telegram bot</b>.<br>' \
           'This is a <i>normal browser page</i>.'
# end def


@app.route("/test", methods=["GET","POST"])
def url_test():
    # your python health check should be here.
    return "Success", 200
# end def


@bot.command("start")
def cmd_start(update, text):
    return HTMLMessage(
        '<b>Hello world</b> from your flask based <a href="https://github.com/luckydonald/docker-telegram-bot/">telegram bot docker container</a>.\n'
        'You can also click the <code>/help</code> <i>bot command</i>: /help'
    )
# end def


@bot.command("help")
def cmd_start(update, text):
    return MarkdownMessage(
        'Here _could_ be help, but instead there is `markdown` formatted example text.\n'
        'Actually, you are writing with a demo bot running in [a docker container](https://github.com/luckydonald/docker-telegram-bot/).'
    )
# end def


@bot.command("example")
def cmd_example(update, text):
    return HTMLMessage('This is an <a href="https://github.com/luckydonald/teleflask">flask</a> based <a href="https://github.com/luckydonald/docker-telegram-bot/">dockerized</a> example bot.')
# end def


@bot.on_message("text")
def msg_caption(update, msg):
    if msg.chat.type == "private":
        return "Wooho, private chat!\n" \
            "This is a format-less post, <b>no html</b> and *no markdown*.\nAlso try the /example command."
    # end if
# end def
