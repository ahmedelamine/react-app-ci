FROM node:20-alpine3.18 as build

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

###
# FROM nginx:1.25-alpine
FROM nginxinc/nginx-unprivileged:1.23-alpine-perl

# Use COPY --link to avoid breaking cache if we change the second stage base image
COPY --link nginx.conf /etc/nginx/conf.d/default.conf

COPY --link --from=build usr/src/app/dist/ /usr/share/nginx/html

EXPOSE 8080