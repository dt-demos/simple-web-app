FROM python:3

WORKDIR /usr/src/app

ENV AUTOWRAPT_BOOTSTRAP=autodynatrace
ENV AUTODYNATRACE_LOG_LEVEL=DEBUG

COPY script.py script.py
COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

CMD [ "python", "./script.py" ]
