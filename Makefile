all: netlogo_6.3.0.tar

netlogo_%.tar: Dockerfile NetLogo-%-64.tgz jdk.tar.gz
	podman build --format docker -t $(@:.tar=:latest) \
		--build-arg NETLOGO_FILE=$(word 2, $^) \
		--build-arg JAVA_FILE=$(word 3, $^) \
		.
	rm -f $@
	podman save $(@:.tar=:latest) -o $@

NetLogo%.tgz:
	wget https://ccl.northwestern.edu/netlogo/$(word 2, $(subst -, ,$@))/$@

jdk.tar.gz:
	wget https://download.java.net/java/GA/jdk19.0.2/fdb695a9d9064ad6b064dc6df578380c/7/GPL/openjdk-19.0.2_linux-x64_bin.tar.gz -O $@
