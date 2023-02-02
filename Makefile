nlrx_6.3.0.sif: %.sif: %.tar


%.sif: %.tar
	singularity build $@ docker-archive://$<


nlrx_%.tar: NetLogo-%-64.tgz Dockerfile
	podman build --format docker -t $(@:.tar=:latest) --build-arg NL_FILE=$< .
	rm -f $@
	podman save $(@:.tar=:latest) -o $@


NetLogo%.tgz:
	wget https://ccl.northwestern.edu/netlogo/$(word 2, $(subst -, ,$@))/$@
