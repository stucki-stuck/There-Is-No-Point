# Ref: https://github.com/astral-sh/uv-docker-example
FROM ghcr.io/astral-sh/uv:python3.13-trixie-slim AS builder
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV UV_PYTHON_DOWNLOADS=0
WORKDIR /app
RUN --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-dev --no-cache
COPY . /app
RUN uv sync --locked --no-dev --no-cache

FROM python:3.13-slim-trixie AS runner
RUN groupadd --system --gid 999 nonroot \
    && useradd --system --gid 999 --uid 999 --create-home nonroot
COPY --from=builder --chown=nonroot:nonroot /app/.venv /app/.venv
COPY --from=builder --chown=nonroot:nonroot /app/src /app/src
ENV PATH="/app/.venv/bin:$PATH"
USER nonroot
EXPOSE 9080
WORKDIR /app
CMD ["gunicorn", "-b", "0.0.0.0:9080", "productpage.app:app", "-w", "8", "--keep-alive", "2", "-k", "gevent"]

FROM builder as builder-dev
RUN uv sync --locked --all-extras --no-cache

FROM runner as dev
COPY --from=builder-dev --chown=nonroot:nonroot /app /app
CMD ["flask", "--app", "productpage.app", "run", "--debug", "--host", "0.0.0.0", "--port", "9080"]
