SIF=netlogo.sif
IMAGE=netlogo
TAG=test
NETLOGO_VERSION=6.3.0


build: Dockerfile NetLogo-${NETLOGO_VERSION}-64.tgz
	podman build --format docker \
		--build-arg NETLOGO_FILE=$(word 2, $^) \
		-t ${IMAGE}:${TAG} \
		.

singularity:
	rm -f $(SIF) $(SIF:.sif=.tar)
	podman save ${IMAGE}:${TAG} -o $(SIF:.sif=.tar)
	singularity build $(SIF) docker-archive://$(SIF:.sif=.tar)
	rm -f $(SIF:.sif=.tar)

NetLogo%.tgz:
	wget https://ccl.northwestern.edu/netlogo/$(word 2, $(subst -, ,$@))/$@
