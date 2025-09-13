# Use an official Node.js runtime as base image
FROM node:18

# Create app directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json ./
RUN npm install

# Copy rest of the app files
COPY . .

# Expose port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
