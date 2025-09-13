# Use official Node.js runtime as base image
FROM node:16-alpine

# Set working directory
WORKDIR /app

# Copy package files from the bookmyshow-app subdirectory
COPY bookmyshow-app/package*.json ./

# Install dependencies
RUN npm install

# Copy application code from the bookmyshow-app subdirectory
COPY bookmyshow-app/ .

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]