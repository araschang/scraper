from base.browser import Browser
import random


class ScrapeService(object):
    def __init__(self):
        self.browser = Browser().get_browser()
        self.results = {}
    
    def scrape(self, to_scrape_urls: list):
        for url in to_scrape_urls:
            self.browser.get(url)
            self.results[url] = self.browser.page_source
        return self.results
