ARG CONDA_VERSION=py311_23.9.0-0

#########################################
# Base
#########################################
FROM docker.io/opensuse/leap:15.4 AS base

# Install general utilities:
#   - R depends on which
#   - rdwd update needs on tar, gzip
#   - R help needs less
#   - rdwd needs unzip
RUN zypper refresh && \
    zypper --non-interactive install \
        which less \
        tar gzip unzip \
        && \
    zypper clean --all


#########################################
# Conda environment
#########################################
FROM base AS conda

# Install conda
ARG CONDA_VERSION
RUN curl https://repo.anaconda.com/miniconda/Miniconda3-$CONDA_VERSION-Linux-x86_64.sh -o conda.sh && \
    bash conda.sh -b -p /conda && \
    rm conda.sh && \
    /conda/bin/conda clean -afy

# Create base R environment
ARG R_VERSION
RUN . /conda/etc/profile.d/conda.sh && \
    conda create -p /conda/env -c conda-forge --override-channels --no-default-packages \
        r-base=$R_VERSION \
        && \
    /conda/bin/conda clean -afy

# Install common conda-available packages
RUN . /conda/etc/profile.d/conda.sh && \
    conda activate /conda/env && \
    conda install -c conda-forge --override-channels \
        r-devtools \
        r-remotes \
        r-rcpp \
        r-pbapply \
        r-tidyverse \
        r-sf \
        r-terra \
        && \
    /conda/bin/conda clean -afy

# Install other conda-available packages
RUN . /conda/etc/profile.d/conda.sh && \
    conda activate /conda/env && \
    conda install -c conda-forge --override-channels \
        r-dplyr \
        r-lubridate \
        r-jsonlite \
        r-foreign \
        r-berryfunctions \
        r-xml \
        r-lhs \
        r-furrr \
        r-gensa \
        r-genalg \
        r-raster \
        r-igraph \
        r-progressr \
        r-rcpparmadillo \
        r-boot \
        r-numbers \
        r-foreach \
        r-dtwclust \
        r-pls \
        r-mnormt \
        r-tensora \
        r-nnet \
        r-quantreg \
        r-locfit \
        && \
    /conda/bin/conda clean -afy

# Install non-conda-available packages
RUN . /conda/etc/profile.d/conda.sh && \
    conda activate /conda/env && \
    Rscript -e 'install.packages(c( \
        "nlrx", \
        "rdwd" \
        ), repos="https://cloud.r-project.org")' && \
    /conda/bin/conda clean -afy

# Update rdwd
RUN . /conda/etc/profile.d/conda.sh && \
    conda activate /conda/env  && \
    Rscript -e 'library(rdwd); updateRdwd()'

# Clean files not needed runtime
RUN find -L /conda/env/ -type f -name '*.a' -delete -print && \
    find -L /conda/env/ -type f -name '*.js.map' -delete -print


#########################################
# Final container image
#########################################
FROM base

# Java
ARG JAVA_VERSION
RUN zypper refresh && \
    zypper --non-interactive install \
        java-$JAVA_VERSION-openjdk-headless \
        && \
    zypper clean --all

# NetLogo
ARG NETLOGO_FILE
ARG NETLOGO_VERSION
ADD $NETLOGO_FILE /

# Conda
COPY --from=conda /conda/env/ /conda/env/

ENV JAVA_HOME=/usr/lib64/jvm/java-$JAVA_VERSION-openjdk-$JAVA_VERSION \
    NETLOGO_HOME="/NetLogo $NETLOGO_VERSION" \
    NETLOGO_VERSION=$NETLOGO_VERSION \
    PROJ_DATA=/conda/env/share/proj \
    PATH=/conda/env/bin:$PATH \
    LC_ALL=C.UTF-8

ENTRYPOINT ["Rscript"]
CMD ["--help"]
