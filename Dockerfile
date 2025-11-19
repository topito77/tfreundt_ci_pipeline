# Pick a base image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install uv as per official docs
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy uv project configuration, "." means copy into workdir
COPY pyproject.toml .
COPY uv.lock .
COPY .python-version .

# Copy project files
COPY notebooks/* notebooks/
COPY input/* input/

# Install dependencies with uv inside the container
RUN uv sync

# Expose port for marimo... this is the port we will run on
EXPOSE 8080

# Run marimo with uv... i.e. let people in through port 8080
CMD ["uv", "run", "marimo", "run", "--host", "0.0.0.0", "--port", "8080", "notebooks/spotify_eda.py"]