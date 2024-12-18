FROM ubuntu:latest
# docker run --rm -d -p 18443:443 -p 3478:3478/udp 2ebfcd77f938
# Set working directory
WORKDIR /app

# ========= CONFIG =========
# - derper args
ENV DERP_HOST=127.0.0.1
ENV DERP_CERTS=/app/certs
ENV DERP_STUN=true
# 如果你在中国请设置为 true
ENV CHANGE_SOURCE=true 
ENV DERP_VERIFY_CLIENTS=false
# ==========================

# ARG to control source change
ARG CHANGE_SOURCE=false

# Change application source if required (only for Ubuntu-based images)
RUN if [ "$CHANGE_SOURCE" = "true" ]; then \
    # Change application source from archive.ubuntu.com to mirrors.aliyun.com \
    sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list; \
    fi

# Install dependencies
RUN apt-get update && apt-get install -y bash openssl curl gcc make && rm -rf /var/lib/apt/lists/*

# Create /app directory and set permissions
RUN mkdir -p /app 

# Copy required files
COPY build_cert.sh /app/
COPY ./derper /app/

# Ensure the derper file has execute permissions
RUN  chmod +x -R /app

# Debugging: Check if the file exists and has execute permission
RUN ls -l /app/
RUN /app/build_cert.sh $DERP_HOST $DERP_CERTS /app/san.conf
# Build self-signed certs and run derper in one CMD to avoid overwriting
CMD /app/derper --hostname=$DERP_HOST \
    --certmode=manual \
    --certdir=$DERP_CERTS \
    --stun=$DERP_STUN  \
    --verify-clients=$DERP_VERIFY_CLIENTS

                                           