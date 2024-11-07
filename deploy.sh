docker stop scraper

docker rm scraper

docker rmi scraper

docker build -t scraper .

docker run -d --name scraper -p 8000:8000 --restart unless-stopped scraper

docker system prune -f