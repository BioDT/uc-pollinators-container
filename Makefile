IMAGE_ROOT?=ghcr.io/biodt
IMAGE=beehave
IMAGE_VERSION=0.3.3
NETLOGO_VERSION=6.3.0
JAVA_VERSION=17
R_VERSION=4.2


build: Dockerfile NetLogo-${NETLOGO_VERSION}-64.tgz
	docker build \
		--label "org.opencontainers.image.source=https://github.com/BioDT/uc-pollinators-container" \
		--label "org.opencontainers.image.description=BEEHAVE environment with NetLogo ${NETLOGO_VERSION}, OpenJDK ${JAVA_VERSION}, R ${R_VERSION}" \
		--build-arg NETLOGO_FILE=$(word 2, $^) \
		--build-arg NETLOGO_VERSION=${NETLOGO_VERSION} \
		--build-arg JAVA_VERSION=${JAVA_VERSION} \
		--build-arg R_VERSION=${R_VERSION} \
		-t ${IMAGE_ROOT}/${IMAGE}:${IMAGE_VERSION} \
		.

push:
	docker push ${IMAGE_ROOT}/${IMAGE}:${IMAGE_VERSION}

singularity:
	rm -f $(IMAGE).sif $(IMAGE).tar
	docker save $(IMAGE_ROOT)/$(IMAGE):$(IMAGE_VERSION) -o $(IMAGE).tar
	singularity build $(IMAGE).sif docker-archive://$(IMAGE).tar
	rm -f $(IMAGE).tar

NetLogo%.tgz:
	wget https://ccl.northwestern.edu/netlogo/$(word 2, $(subst -, ,$@))/$@
