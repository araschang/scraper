#!/bin/bash

# Start Xvfb in the background and redirect output to a log file
Xvfb :99 -screen 0 1920x1080x24 > /tmp/xvfb_output.log 2>&1 &

# Maximum wait time (in seconds) for XNNPACK delegate initialization
MAX_WAIT_TIME=15  # Adjust as needed
WAIT_INTERVAL=1
elapsed_time=0

start_chrome() {
    # Start Chrome in the background and redirect output to a log file
    chrome --remote-debugging-port=9222 --no-sandbox --disable-dev-shm-usage --disable-gpu --disable-software-rasterizer > /tmp/chrome_output.log 2>&1 &
    echo "Chrome started."
}

# Start Chrome for the first time
start_chrome

# Wait for the specific message to appear in the Chrome log
echo "Waiting for TensorFlow Lite XNNPACK delegate to initialize..."
while ! grep -q "Created TensorFlow Lite XNNPACK delegate for CPU" /tmp/chrome_output.log; do
    sleep $WAIT_INTERVAL
    elapsed_time=$((elapsed_time + WAIT_INTERVAL))

    # Check if maximum wait time has been exceeded
    if [ "$elapsed_time" -ge "$MAX_WAIT_TIME" ]; then
        echo "XNNPACK delegate initialization not detected. Restarting Chrome..."
        pkill -f "google-chrome"  # Kill Chrome
        sleep 2  # Wait briefly to ensure Chrome has terminated
        start_chrome  # Restart Chrome
        elapsed_time=0  # Reset the timer
    fi
done

echo "TensorFlow Lite XNNPACK delegate initialized, starting Gunicorn..."

# Start Gunicorn or your main application process
gunicorn -w 1 -b 0.0.0.0:8000 wsgi:app --log-level=debug --timeout 0
