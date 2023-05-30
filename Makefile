IMAGE_ROOT?=localhost
IMAGE=beehave
SIF=${IMAGE}.sif
TAG=0.3.3
NETLOGO_VERSION=6.3.0
JAVA_VERSION=17
R_VERSION=4.2


build: Dockerfile NetLogo-${NETLOGO_VERSION}-64.tgz
	podman build --format docker \
		--label "org.opencontainers.image.source=https://github.com/BioDT/uc-beehave-singularity-for-lumi" \
		--label "org.opencontainers.image.description=BEEHAVE environment with NetLogo ${NETLOGO_VERSION}, OpenJDK ${JAVA_VERSION}, R ${R_VERSION}" \
		--build-arg NETLOGO_FILE=$(word 2, $^) \
		--build-arg NETLOGO_VERSION=${NETLOGO_VERSION} \
		--build-arg JAVA_VERSION=${JAVA_VERSION} \
		--build-arg R_VERSION=${R_VERSION} \
		-t ${IMAGE_ROOT}/${IMAGE}:${TAG} \
		.

push:
	podman push ${IMAGE_ROOT}/${IMAGE}:${TAG}

singularity:
	rm -f $(SIF) $(SIF:.sif=.tar)
	podman save ${IMAGE}:${TAG} -o $(SIF:.sif=.tar)
	singularity build $(SIF) docker-archive://$(SIF:.sif=.tar)
	rm -f $(SIF:.sif=.tar)

NetLogo%.tgz:
	wget https://ccl.northwestern.edu/netlogo/$(word 2, $(subst -, ,$@))/$@
