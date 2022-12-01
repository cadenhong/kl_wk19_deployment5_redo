FROM python:latest
WORKDIR /url-shortener
COPY . .
RUN apt update
RUN pip3 install -r requirements.txt
RUN pip3 install gunicorn
EXPOSE 8000
ENTRYPOINT python3 -m gunicorn -w 4 application:app -b 0.0.0.0:8000