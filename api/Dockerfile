FROM python:3.9.1-buster

RUN pip install poetry
RUN poetry config virtualenvs.create false

WORKDIR /app
COPY poetry.lock /app/
COPY pyproject.toml /app/

RUN poetry install --no-dev

COPY seabee_back /app/seabee_back

RUN poetry install --no-dev

ARG GIT_COMMIT_ID=unknown
LABEL git_commit_id=$GIT_COMMIT_ID
ENV GIT_COMMIT_ID=$GIT_COMMIT_ID

CMD ["python", "/app/seabee_back/main.py"]
#CMD ["sleep", "300"]
