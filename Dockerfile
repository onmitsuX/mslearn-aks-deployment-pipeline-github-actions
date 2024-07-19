
The exit code 100 usually indicates that there is an issue with the package manager or one of the commands in the RUN statement. This could be due to missing dependencies, incorrect URLs, or issues with the package repositories.

Let's debug this step-by-step. I'll modify the Dockerfile to add more logging and split the RUN command into multiple steps for better clarity.

Here's the updated Dockerfile:

Dockerfile
Copy code
FROM nginx:1.18

# Update package lists and install basic dependencies
RUN apt-get update -y && \
    apt-get install -y curl gnupg2

# Add Node.js repository and install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update -y && \
    apt-get install -y git nodejs

# Install Hugo
RUN curl -sL https://github.com/gohugoio/hugo/releases/download/v0.72.0/hugo_extended_0.72.0_Linux-64bit.tar.gz | \
    tar -xz && \
    mv hugo /usr/bin

# Install PostCSS CLI and plugins
RUN npm install -g postcss-cli autoprefixer postcss

# Clone the repository
RUN git clone https://github.com/MicrosoftDocs/mslearn-aks-deployment-pipeline-github-actions /contoso-website

WORKDIR /contoso-website/src

# Update submodules
RUN git submodule update --init themes/introduction

# Build the Hugo site
RUN hugo

# Move the built files to the nginx html directory
RUN mv public/* /usr/share/nginx/html

# Expose port 80
EXPOSE 80
