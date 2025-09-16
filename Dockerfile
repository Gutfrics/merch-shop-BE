# Base Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    gettext \
    && rm -rf /var/lib/apt/lists/*

# Install pipenv (or pip-tools, depending on your Saleor fork)
RUN pip install --no-cache-dir pipenv

# Copy dependency files
COPY Pipfile Pipfile.lock ./

# Install Python dependencies
RUN pipenv install --deploy --ignore-pipfile

# Copy project files
COPY . .

# Collect static files
RUN pipenv run python manage.py collectstatic --noinput

# Expose port
EXPOSE 8000

# Start Saleor
CMD ["pipenv", "run", "gunicorn", "saleor.wsgi:application", "--bind", "0.0.0.0:8000"]