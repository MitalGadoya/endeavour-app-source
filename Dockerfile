# Stage 1: Build stage
FROM python:3.12-alpine as builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

COPY app/app.py .

# Stage 2: Final image (small, non-root)
FROM python:3.12-alpine

# Create non-root user
RUN adduser -S -h /home/appuser appuser

WORKDIR /home/appuser
COPY --from=builder /root/.local /home/appuser/.local
COPY --from=builder /app/app.py .

# Update PATH for pip user installs
ENV PATH=/home/appuser/.local/bin:$PATH

# Switch to non-root user
USER appuser

EXPOSE 5000
CMD ["python", "app.py"]

