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

First a docker image is built and then converted to singularity.
The workflow is encoded in Makefile:

    make

This produces `nlrx_6.3.0.sif` to be transferred to lumi:

    rsync -v nlrx_6.3.0.sif lumi:...


## Running image on LUMI

Use working directory under `/scratch/project_...`.

Copy the example job script (`submit.sh`)
and edit the job options (`#SBATCH ...`)
and the file paths to the image file (`SIF`) and R script (`RSCRIPT`).

The rest of the script should work without modification.

Submit the job using `sbatch submit.sh`.
