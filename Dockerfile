FROM node:12-alpine 

WORKDIR /app
COPY package*.json ./
RUN npm install

WORKDIR /app
COPY . .
RUN npm run build

FROM node:12-alpine as application
COPY --from=0 /app/package*.json ./
RUN npm install --only=production
COPY --from=0 /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["node", "dist/main.js"]