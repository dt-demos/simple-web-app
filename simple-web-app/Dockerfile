FROM node:12

# Create app directory
WORKDIR /usr/src/app

ARG SERVICE_NAME=simple-web-app
ENV SERVICE_NAME=$SERVICE_NAME
ENV SERVICE_TO_CALL_URL=

# Bundle app source
COPY . .

RUN npm update
RUN npm install

EXPOSE 8080
CMD [ "npm", "start" ]
