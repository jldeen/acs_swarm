FROM jldeen/alpine-docker
MAINTAINER jessde@microsoft.com

# Copy private key - update path accordingly for location of private key
COPY id_rsa /root/.ssh/id_rsa

# Turn SSH on and add private key to identities
RUN eval `ssh-agent -s` && /usr/bin/ssh-add /root/.ssh/id_rsa

# Azure ENV for Azure Login
ENV spn=[insert-content-here]
ENV tenant=[insert-content-here]

# Set DOCKER_HOST Env Variable
ENV DOCKER_HOST=:2375

# Set ACS Tunnel Variables 
ENV Servicename=[insert-content-here]
ENV Resource=[insert-content-here]
ENV local_port=2375
ENV remote_port=2375

# Confirm env var set properly - testing only
RUN echo $DOCKER_HOST

# Expose port for container
EXPOSE 2375

# Copy SSH Tunnel Script and make executable
COPY sshtunnel/ssh-tunnel.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/ssh-tunnel.sh

# Open SSH tunnel
ENTRYPOINT ["/usr/local/bin/ssh-tunnel.sh"]

CMD ["sh"] 