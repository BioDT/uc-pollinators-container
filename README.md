# Singularity image for LUMI


## Building image

First a parent docker image with Java and NetLogo is built and then
[the container wrapper](https://docs.lumi-supercomputer.eu/software/installing/container-wrapper/)
on LUMI is used to add the R environment on top of the parent image


### Building the parent image

Build the parent image on a local machine.
These instructions assume Ubuntu 22.04 and require podman
(`sudo apt install podman-docker`).


The workflow is encoded in Makefile (no sudo needed):

    make

This produces `netlogo_6.3.0.tar` to be transferred to LUMI:

    rsync -v netlogo_6.3.0.tar lumi:...


### Building the parent image

Build the parent image on LUMI.

TOD


## Running image on LUMI

* Use working directory under scratch

      cd /scratch/project_...

* Copy the example job script (`submit.sh`)

  * Edit the file paths to the image file (`SIF`) and R script (`RSCRIPT`)

  * Edit the job options (`#SBATCH ...`)

  * The rest of the script should work without modification.

* Submit the job

      sbatch submit.sh
