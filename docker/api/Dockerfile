FROM python:3.10
ENV PYTHONUNBUFFERED=1

COPY ./src /app
WORKDIR /app

RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="${PATH}:/root/.local/bin"
RUN poetry config virtualenvs.create false
RUN poetry install
RUN cp .env.example .env
RUN alembic upgrade head
CMD python api.py
