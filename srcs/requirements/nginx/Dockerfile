# Use the official Debian Bullseye image
FROM debian:bullseye

# Update package lists and install Nginx and OpenSSL
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /.secrets/ && \
    echo "Nginx and OpenSSL installed."

# Generate SSL certificates using OpenSSL
RUN openssl req -x509 -nodes -days 1 -newkey rsa:4096 \
    -keyout /.secrets/key.key \
    -out /.secrets/cert.crt \
    -sha256 \
    -subj "/C=UA/ST=Odessa/L=Odessa/O=SamsungPc/OU=smoreron/CN=smoreron" && \
    echo "SSL certificates generated."

# Copy the Nginx default configuration file
COPY ./conf/default /etc/nginx/sites-available/

# Print a configuration complete message
RUN echo "Configuration complete."

# Expose port 443 for HTTPS
EXPOSE 443

# Set the entrypoint to Nginx and run it in the foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]

# Use the default Nginx configuration file
CMD ["-c", "/etc/nginx/nginx.conf"]
