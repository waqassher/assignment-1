
FROM node:alpine AS builder
WORKDIR /app
COPY index.html .

# Stage 2: Production stage
FROM nginx:alpine
COPY --from=builder /app/index.html /usr/share/nginx/html/index.html
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
