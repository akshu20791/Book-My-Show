FROM node:18-alpine

WORKDIR /app

# Copy only package.json and package-lock.json (if present) from bookmyshow-app
COPY bookmyshow-app/package*.json ./

RUN npm install

# Copy entire source code from bookmyshow-app
COPY bookmyshow-app/. .

EXPOSE 3000

CMD ["npm", "start"]

