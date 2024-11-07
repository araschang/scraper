from flask_restful import Api
from flask import Flask
from controller.scrape import ScrapeController
import subprocess

app = Flask(__name__)
api = Api(app)



# # Define the Chrome command and options
# chrome_command = [
#     "google-chrome",
#     "--remote-debugging-port=9222",
#     "--no-sandbox",
#     "--disable-dev-shm-usage",
#     "--disable-gpu",
#     "--disable-software-rasterizer",
# ]

# # Run the command using subprocess
# process = subprocess.Popen(chrome_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

# # Optional: Print Chrome's output or errors for debugging
# stdout, stderr = process.communicate()

api.add_resource(
    ScrapeController,
    '/api/scrape'
)