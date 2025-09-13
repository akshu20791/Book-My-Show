# Step 1 - Build the React app
FROM node:18-alpine AS build
WORKDIR /app
COPY bookmyshow-app/package*.json ./

# Add this to fix the OpenSSL issue
ENV NODE_OPTIONS=--openssl-legacy-provider

RUN npm install
COPY bookmyshow-app ./
RUN npm run build

# Step 2 - Serve with Nginx
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
