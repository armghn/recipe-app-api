FROM python:3.12-alpine3.19
LABEL maintainer="Armaghan"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

# Use alternative mirror if the default one is slow or down
RUN sed -i 's|dl-cdn.alpinelinux.org|dl-5.alpinelinux.org|g' /etc/apk/repositories && \
    apk add --update --no-cache postgresql14-client postgresql-dev build-base musl-dev && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    apk del build-base musl-dev && \
    rm -rf /var/cache/apk/* /tmp/*

# Create a user for running the application
RUN adduser \
        --disabled-password \
        --no-create-home \
        tech-girl

ENV PATH="/py/bin:$PATH"

USER tech-girl

CMD ["python", "app.py"]
