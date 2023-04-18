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
ARG R_VERSION
ADD conda_env.yaml /tmp/
RUN . $CONDA_HOME/etc/profile.d/conda.sh && \
    sed -i "s/r-base.*/r-base=$R_VERSION/g" /tmp/conda_env.yaml && \
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
ARG CONDA_HOME
ARG CONDA_ENV
COPY --from=conda $CONDA_HOME/ $CONDA_HOME/

ENV JAVA_HOME=/usr/lib64/jvm/java-$JAVA_VERSION-openjdk-$JAVA_VERSION \
    NETLOGO_HOME="/NetLogo $NETLOGO_VERSION" \
    CONDA_HOME=$CONDA_HOME \
    PATH=$CONDA_HOME/envs/$CONDA_ENV/bin:$PATH \
    LC_ALL=C.UTF-8

ENTRYPOINT ["Rscript"]
CMD ["--help"]
