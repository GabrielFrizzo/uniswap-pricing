FROM python:3.11

WORKDIR /app/

RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false

COPY ./pyproject.toml ./poetry.lock* /app/

RUN poetry install --no-root

ENV C_FORCE_ROOT=1

ENV MODULE_NAME=src.background.main
ENV PYTHONPATH=/app/src

COPY ./worker-start.sh /app/worker-start.sh

COPY ./src /app/src

RUN chmod +x /app/worker-start.sh

CMD ["/app/worker-start.sh"]
