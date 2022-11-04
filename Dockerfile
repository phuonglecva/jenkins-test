FROM python:3.8

ENV WORK_DIR=/opt
COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

WORKDIR ${WORK_DIR}
COPY main.py main.py
EXPOSE 8000

CMD [ "uvicorn", "--port", "8000", "--host", "0.0.0.0", "main:app"]