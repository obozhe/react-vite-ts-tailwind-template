# syntax=docker/dockerfile:1
# Install dependencies and build dist
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Host static
FROM nginx:alpine AS deploy
# Copy the build files to the container
COPY --from=build /app/dist /usr/share/nginx/html
# Copy the ngnix.conf to the container
COPY nginx.conf /etc/nginx/nginx.conf
# Expose port 80 for Nginx
EXPOSE 80
# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
