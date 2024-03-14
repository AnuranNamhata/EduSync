# Use the LTS version of Node.js as the base image
FROM node:lts-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application files to the container
COPY . .

# Expose the port that your application will run on
EXPOSE 5000

# Command to run the application
CMD ["npm", "start"]
