from selenium import webdriver
from selenium.webdriver.chrome.service import Service
import platform
import os
import threading

current_system = platform.system()
if current_system == 'Linux':
    chromedriver_path = '/usr/local/bin/chromedriver'
    # chromedriver_path = '/home/aras/chromedriver-linux64/chromedriver'
elif current_system == 'Darwin':
    # chromedriver_path ='/usr/local/bin/chromedriver'
    chromedriver_path = '/Users/araschang/Downloads/chromedriver-mac-arm64 2/chromedriver'
elif current_system == 'Windows':
    # chromedriver_path = os.path.join(os.path.abspath(
    #     os.path.dirname(__file__)
    # ), 'chromedriver.exe')
    chromedriver_path = r'C:\Users\aschang49\Downloads\chromedriver-win64\chromedriver-win64\chromedriver.exe'


class Browser(object):
    _instance = None
    _lock = threading.Lock()
    
    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super(Browser, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def __init__(self):
        if not hasattr(self, "initialized"):
            self.browser = self.get_browser()
            self.initialized = True  # Prevents reinitialization

    def get_browser(self):
        options = webdriver.ChromeOptions()
        options.add_experimental_option("debuggerAddress", "localhost:9222")
        service = Service(executable_path=chromedriver_path)
        browser = webdriver.Chrome(options=options, service=service)
        return browser
        