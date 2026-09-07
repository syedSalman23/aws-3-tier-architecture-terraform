FROM node:24-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY --from=build /app/build .

COPY nginx.conf /etc/nginx/templates/default.conf.template

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]