FROM python:3.10-slim

# Install Google Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update && apt-get install -y google-chrome-stable

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV CHROME_PATH=/usr/bin/google-chrome-stable
ENV PYTHONUNBUFFERED=1
ENV MAX_WORKERS=1          # Kurangi pekerja agar hemat memori

CMD ["python", "service.py"]
