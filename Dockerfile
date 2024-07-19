FROM nginx:1.18

# Install dependencies
RUN apt-get update -y && \
    apt-get install -y curl gnupg && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y git nodejs npm

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
