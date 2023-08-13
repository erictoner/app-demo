# using alpine with python3.11.4
FROM python:3.11.4-alpine

WORKDIR /usr/src/app

COPY app/ ./
RUN pip install --no-cache-dir -r requirements.txt

CMD [ "python", "./api.py" ]
