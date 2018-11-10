

FROM python:3-alpine AS base

WORKDIR /app
RUN pip install pipenv==2018.10.13

COPY Pipfile /app/
COPY Pipfile.lock /app/

RUN pipenv install --system --deploy


FROM base AS app
COPY src /app


FROM base AS test-base
RUN pipenv install --system --deploy --dev
COPY src /app


FROM test-base AS Test
RUN pytest --black


FROM test-base AS Check
RUN safety check


FROM app AS Security
ARG MICROSCANNER
RUN wget -O /microscanner https://get.aquasec.com/microscanner && chmod +x /microscanner
RUN /microscanner $MICROSCANNER --full-output


FROM test-base AS Docs
RUN pycco -i *.py*
WORKDIR /app/docs
EXPOSE 8000
CMD ["python", "-m", "http.server"]


FROM app AS Shell
CMD ["flask", "shell"] 


FROM app AS release
EXPOSE 5000
CMD ["python", "app.py"]


FROM release AS Dev
ENV FLASK_ENV=development


FROM release As Prod
CMD ["gunicorn", "-b", ":5000", "app:app"]
