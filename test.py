#!/usr/bin/env python
# -*- encoding: utf-8 -*-
# Created on 2017-12-01 09:16:05
# Project: hz

from pyspider.libs.base_handler import *


class Handler(BaseHandler):
    crawl_config = {
    }
    
    def __init__(self):
        self.base_url = 'http://so.571xz.com/hzgoods.htm?webSite=hz&pid=16&mid=601&sort=xp&page='
        self.page_num = 1
        self.total_num = 30    
    
    @every(minutes=24 * 60)
    def on_start(self):
        while self.page_num <= self.total_num:
            url = self.base_url + str(self.page_num)
            self.crawl(url, callback=self.index_page)
            self.page_num += 1

    @config(age=10 * 24 * 60 * 60)
    def index_page(self, response):
        for each in response.doc('.goodsitem .imgbox').items():
            self.crawl(each.attr.href, callback=self.detail_page)

    @config(priority=2)
    def detail_page(self, response):
        return {
            "url": response.url,
            "title": response.doc('.goodsTitle h2 a').text(),
            "item_id":response.doc('.goodsTitle h2 a').attr.href,
            "store_name":response.doc('.storeNamebox h3').text(),
            "imgs":[x.attr('data-original') for x in response.doc('.goodsDetail .lazyload').items()],
            "props":[x.text() for x in response.doc('.goodsAttribute li').items()]
        }