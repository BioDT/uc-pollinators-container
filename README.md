# Singularity image for LUMI

## Usage

### Pulling the image on LUMI

Pull the pre-built image on LUMI:
```bash
singularity pull --docker-login beehave.sif docker://ghcr.io/biodt/beehave:0.3.0
```
This creates singularity image file `beehave.sif`.

Note that the image is for now private, which means that login is required.
Follow [these instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-personal-access-token-classic)
and create a classic personal access token with scope 'read:packages'.
Then, use your GitHub username and the created token in the login prompt of `singularity pull`.

### Running the image on LUMI

* Use working directory under scratch

      cd /scratch/project_...

* Copy the example job script (`submit.sh`)

  * Edit the file paths to the image file (`SIF`) and R script (`RSCRIPT`)

  * Edit the job options (`#SBATCH ...`)

  * The rest of the script should work without modification.

* Submit the job

      sbatch submit.sh


## Advanced: Building a new image

Build the parent image on a local machine
(tested on Ubuntu 22.04 with podman, `sudo apt install podman-docker`).

The container recipe is encoded in `Dockerfile` and `Makefile`.

Set image path for building and pushing:
```bash
export IMAGE_ROOT=ghcr.io/biodt
```

Build the image:
```bash
make
```

Push the image:
```bash
podman login ${IMAGE_ROOT%%/*}
make push
```
(login using classic personal access token with scope 'write:packages').

For testing, convert the local image to singularity:
```bash
make singularity
```
