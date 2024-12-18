FROM alpine:latest
# docker run --rm -d -p 18443:443 -p 3478:3478/udp 2ebfcd77f938
# Set working directory
WORKDIR /app

# ========= CONFIG =========
# - derper args
ENV DERP_HOST=127.0.0.1
ENV DERP_CERTS=/app/certs
ENV DERP_STUN=true
ENV CHANGE_SOURCE=true
ENV DERP_VERIFY_CLIENTS=false
# ==========================

ARG CHANGE_SOURCE=false
RUN if [ ${CHANGE_SOURCE} = "true" ]; then \
    # Change application source from dl-cdn.alpinelinux.org to aliyun source
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
;fi

RUN apk update \
    && apk upgrade \
    && apk --update add logrotate \
    && apk add --no-cache openssl \
    && apk add --no-cache bash \
    && apk add --no-cache gcc

RUN apk add --no-cache curl

# Create /app directory and set permissions
RUN mkdir -p /app 

# Copy required files
COPY build_cert.sh /app/
COPY ./derper /app/

# Ensure the derper file has execute permissions
RUN  chmod +rx -R /app

# Debugging: Check if the file exists and has execute permission
RUN ls -l /app/
RUN /app/build_cert.sh $DERP_HOST $DERP_CERTS /app/san.conf
# Build self-signed certs and run derper in one CMD to avoid overwriting
# start derper
CMD /app/derper --hostname=$DERP_HOST \
    --certmode=manual \
    --certdir=$DERP_CERTS \
    --stun=$DERP_STUN  \
    --verify-clients=$DERP_VERIFY_CLIENTS
