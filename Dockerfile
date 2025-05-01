# Use official Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy dependency file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Expose port if needed (e.g., for Flask)
EXPOSE 5000

# Set environment variables (you'll override this using Docker's --env-file)
ENV PYTHONUNBUFFERED=1

# Run your app
CMD ["python", "app.py"]
