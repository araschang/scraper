# Use Python 3.12 slim image for linux/amd64
FROM --platform=linux/amd64 python:3.12-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and system tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    xvfb \
    gnupg2 \
    build-essential \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    lsb-release \
    xdg-utils \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Define versions
ENV CHROME_VERSION=1000000
ENV CHROMEDRIVER_VERSION=1000000

# Download and install Chromium
RUN wget -O /tmp/chrome-linux.zip "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F${CHROME_VERSION}%2Fchrome-linux.zip?alt=media" && \
    unzip /tmp/chrome-linux.zip -d /opt/ && \
    rm /tmp/chrome-linux.zip && \
    ln -s /opt/chrome-linux/chrome /usr/bin/chrome

# Download and install ChromeDriver
RUN wget -O /tmp/chromedriver_linux64.zip "https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F${CHROMEDRIVER_VERSION}%2Fchromedriver_linux64.zip?alt=media" && \
    unzip /tmp/chromedriver_linux64.zip -d /tmp/ && \
    mv /tmp/chromedriver_linux64/chromedriver /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver_linux64.zip

# Ensure ChromeDriver is executable
RUN chmod +x /usr/local/bin/chromedriver

# Set environment variables for Chrome and ChromeDriver paths
ENV DISPLAY=:99 \
    CHROME_BIN=/usr/bin/google-chrome \
    CHROMEDRIVER_PATH=/usr/local/bin/chromedriver


# Copy the Python backend files
COPY . /app
WORKDIR /app

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy the start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose the port for Flask or Gunicorn
EXPOSE 8000

# Command to run Chrome in remote debugging mode and start Gunicorn for Flask app
CMD Xvfb :99 -screen 0 1920x1080x24 & \ 
    gunicorn -w 1 -b 0.0.0.0:8000 wsgi:app --log-level=debug --timeout 0
# # Use the start script as the entry point
# CMD ["/start.sh"]
