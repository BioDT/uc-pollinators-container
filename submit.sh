#!/bin/bash -l
#SBATCH -J test
#SBATCH --partition=small
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00
#SBATCH --account=project_....

# Use correct file paths here
SIF="nlrx_6.3.0.sif"
RSCRIPT="nlrx_script.R"

####################################
# No need to edit the lines below
####################################

# NetLogo pollutes home directory with .java and .netlogo directories, so
# we use a temporary home directory in singularity
TMP_HOME=`mktemp -d -p /tmp`

# Create a base directory manually to suppress messages from NetLogo
mkdir -p $TMP_HOME/.java/.userPrefs

# Remove temporary home directory at exit
# Note: One could do "rm -rf $TMP_HOME", but we don't do it as a safeguard in case
# someone would modify TMP_HOME to be the real home and get everything erased there
trap "rm -r $TMP_HOME/.java $TMP_HOME/.netlogo; rmdir $TMP_HOME" EXIT

# Run nlrx
singularity exec --home $TMP_HOME --bind $PWD $SIF Rscript $RSCRIPT
