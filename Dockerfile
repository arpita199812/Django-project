FROM node:16

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm config set registry https://registry.npm.taobao.org && \
    npm config set timeout 600000 && \
    npm config set strict-ssl false && \
    until npm install; do echo "Retrying npm install..."; done
    
# Bundle app source
COPY . .

# Expose the port the app runs on
EXPOSE 8081

# Define the command to run the app
CMD ["npm", "start"]

