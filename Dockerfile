FROM docker.io/opensuse/leap:15.3

# Container wrapper seems to mask various standard paths so
# we install everything under /my

# Add java
ARG JAVA_FILE
ADD $JAVA_FILE /my/

# Add NetLogo
ARG NETLOGO_FILE
ADD $NETLOGO_FILE /my/

ENV JAVA_HOME=/my/jdk-19.0.2 \
    NETLOGO_HOME="/my/NetLogo 6.3.0" \
    LC_ALL=C.UTF-8

CMD ["sh"]
