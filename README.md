# Singularity image for LUMI


## Building image

Build images on a local machine.
These instructions assume Ubuntu 22.04.

### Prerequisites

* Podman (or docker):

      sudo apt install podman-docker

* Singularity:

      wget https://github.com/sylabs/singularity/releases/download/v3.10.5/singularity-ce_3.10.5-jammy_amd64.deb
      sudo dpkg -i singularity-ce_3.10.5-jammy_amd64.deb
      sudo apt install -f


### Building

First a docker image is built and then converted to a singularity image.
Building the nlrx dependencies takes some time (~1 hour).
The workflow is encoded in Makefile (no sudo needed):

    make

This produces `nlrx_6.3.0.sif` to be transferred to LUMI:

    rsync -v nlrx_6.3.0.sif lumi:...


## Running image on LUMI

* Use working directory under scratch

      cd /scratch/project_...

* Copy the example job script (`submit.sh`)

  * Edit the file paths to the image file (`SIF`) and R script (`RSCRIPT`)

  * Edit the job options (`#SBATCH ...`)

  * The rest of the script should work without modification.

* Submit the job

      sbatch submit.sh
