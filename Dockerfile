FROM docker.io/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qy && \
    apt-get install -qy \
        gpg \
        ca-certificates \
        software-properties-common \
        && \
    apt-get clean

# Add repository for newer R
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

# Install R and dependencies for nlrx
RUN apt-get update -qy && \
    apt-get install -qy \
        r-base-dev \
        libxml2-dev \
        libgdal-dev \
        libudunits2-dev \
        && \
    apt-get clean

# Install nlrx
RUN Rscript -e 'install.packages("nlrx", repos="https://cloud.r-project.org")'

# Install java
RUN apt-get install -qy \
        openjdk-17-jre-headless \
        && \
    apt-get clean

ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"

# Add NetLogo
ADD NetLogo-6.3.0-64.tgz /

CMD ["sh"]
