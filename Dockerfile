FROM node:12-alpine as base 

WORKDIR /app
COPY package*.json ./
RUN npm install

WORKDIR /app
COPY . .
RUN npm run build

FROM node:12-alpine as application
COPY --from=base /app/package*.json ./
RUN npm install --only=production
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["node", "dist/main.js"]