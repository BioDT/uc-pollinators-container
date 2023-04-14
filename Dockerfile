ARG CONDA_HOME=/conda
ARG CONDA_ENV=beehave
ARG CONDA_VERSION=py310_23.1.0-1


#########################################
# Base
#########################################
FROM docker.io/opensuse/leap:15.4 AS base

# Install `which`, which R depends on
RUN zypper refresh && \
    zypper --non-interactive install \
        which \
        && \
    zypper clean --all


#########################################
# Conda environment
#########################################
FROM base AS conda
ARG CONDA_HOME
ARG CONDA_ENV
ARG CONDA_VERSION

# Conda
RUN curl https://repo.anaconda.com/miniconda/Miniconda3-$CONDA_VERSION-Linux-x86_64.sh -o conda.sh && \
    bash conda.sh -b -p $CONDA_HOME && \
    rm conda.sh && \
    $CONDA_HOME/bin/conda clean -afy

# Install conda-available R packages
ADD conda_env.yaml /tmp/
RUN . $CONDA_HOME/etc/profile.d/conda.sh && \
    conda env create -f /tmp/conda_env.yaml -p $CONDA_HOME/envs/$CONDA_ENV && \
    $CONDA_HOME/bin/conda clean -afy

# Install non-conda-available R packages
ADD post-install.sh /tmp/
RUN . $CONDA_HOME/etc/profile.d/conda.sh && \
    conda activate $CONDA_ENV && \
    bash /tmp/post-install.sh

# Clean files not needed runtime
RUN find -L $CONDA_HOME/ -type f -name '*.a' -delete && \
    find -L $CONDA_HOME/ -type f -name '*.js.map' -delete && \
    $CONDA_HOME/bin/conda clean -afy


#########################################
# Final container image
#########################################
FROM base

# Java
RUN zypper refresh && \
    zypper --non-interactive install \
        java-17-openjdk-headless \
        && \
    zypper clean --all

# NetLogo
ARG NETLOGO_FILE
ADD $NETLOGO_FILE /

# Conda
ARG CONDA_HOME
ARG CONDA_ENV
COPY --from=conda $CONDA_HOME/ $CONDA_HOME/

ENV JAVA_HOME=/usr/lib64/jvm/java-17-openjdk-17 \
    NETLOGO_HOME="/NetLogo 6.3.0" \
    CONDA_HOME=$CONDA_HOME \
    PATH=$CONDA_HOME/envs/$CONDA_ENV/bin:$PATH \
    LC_ALL=C.UTF-8

ENTRYPOINT ["Rscript"]
CMD ["--help"]
