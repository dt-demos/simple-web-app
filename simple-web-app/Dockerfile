FROM node:12

# Create app directory
WORKDIR /usr/src/app

# used to set the package service name
ARG SERVICE_NAME=simple-web-app
ENV SERVICE_NAME=$SERVICE_NAME

# set env vars that the application uses
ENV SERVICE_TO_CALL_URL=none

# Bundle app source
COPY . .
COPY package-lock.json ./package-lock.json.orig
COPY package.json ./package.json.orig
COPY MANIFEST MANIFEST

# adjust the node application name as to be unique
RUN cat ./package-lock.json.orig | sed 's|"name":.*|"name": "'$SERVICE_NAME'",|g' > ./package-lock.json
RUN cat ./package.json.orig | sed 's|"name":.*|"name": "'$SERVICE_NAME'",|g' > ./package.json

RUN npm update
RUN npm install

EXPOSE 8080
CMD [ "npm", "start" ]
