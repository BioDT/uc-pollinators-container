.PHONY: all

NL_VERSION=6.3.0

all: nlrx_${NL_VERSION}.sif


nlrx_${NL_VERSION}.sif: nlrx_${NL_VERSION}.tar
	singularity build $@ docker-archive://$<


nlrx_${NL_VERSION}.tar: NetLogo-${NL_VERSION}-64.tgz
	podman build --format docker -t $(@:.tar=:latest) .
	podman save $(@:.tar=:latest) -o $@


NetLogo-${NL_VERSION}-%.tgz:
	wget https://ccl.northwestern.edu/netlogo/${NL_VERSION}/$@
