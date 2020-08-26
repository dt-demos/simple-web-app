FROM node:12

# Create app directory
WORKDIR /usr/src/app

ARG SERVICE_NAME=simple-web-service
ENV SERVICE_NAME=$SERVICE_NAME
ENV SERVICE_TO_CALL_URL=

# Bundle app source
COPY . .
COPY package-lock.json ./package-lock.json.orig
COPY package.json ./package.json.orig

# adjust the node application name as to be unique
RUN cat ./package-lock.json.orig | sed 's|"name":.*|"name": "'$SERVICE_NAME'",|g' > ./package-lock.json
RUN cat ./package.json.orig | sed 's|"name":.*|"name": "'$SERVICE_NAME'",|g' > ./package.json

RUN npm update
RUN npm install

EXPOSE 8080
CMD [ "npm", "start" ]
