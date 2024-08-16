# Use Node.js to build and serve the app
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the application
RUN npm run build

# Install `serve` to serve the built files
RUN npm install -g serve

# Expose the port where the app will run
EXPOSE 3000

# Command to serve the built files
CMD ["serve", "-s", "dist", "-l", "3000"]
