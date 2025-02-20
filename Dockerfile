# Stage 1: Building the code
FROM node:alpine AS builder

WORKDIR /app

COPY package.json yarn.lock ./

RUN npm install 

COPY . .

RUN npm run build

RUN npm install


# Stage 2: And then copy over node_modules, etc from that stage to the smaller base image
FROM node:alpine as production

WORKDIR /app

# COPY package.json next.config.js .env* ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000

CMD ["node_modules/.bin/next", "start"]
