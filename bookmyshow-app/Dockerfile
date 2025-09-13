# Use official Node.js base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy everything first
COPY . .

# Then run npm install
RUN npm install

# Expose the port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]

