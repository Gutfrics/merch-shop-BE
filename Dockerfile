FROM python:3.11-slim

# Set workdir
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    gettext \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install --no-cache-dir poetry

# Copy dependency files
COPY pyproject.toml poetry.lock* ./

# Install dependencies
RUN poetry install --no-dev --no-interaction --no-ansi

# Copy project files
COPY . .

# Collect static files
RUN poetry run python manage.py collectstatic --noinput

# Expose port
EXPOSE 8000

# Start app
CMD ["poetry", "run", "gunicorn", "saleor.wsgi:application", "--bind", "0.0.0.0:8000"]