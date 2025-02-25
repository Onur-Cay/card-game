# Use Node.js 18 as the base image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy package files
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy the rest of the project
COPY . .

# Build the Next.js app
RUN yarn build

# Expose port 3000
EXPOSE 3000

# Start the app in production mode
CMD ["yarn", "start"]
