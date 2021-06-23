#!/bin/bash

#Folder for all outputs
mkdir outputs_assembly
#starting with A5 pipeline assembler
a5_pipeline $1 $2 $3 
#Move result to output folder
find . -name '*.contigs.fasta' -exec mv {} outputs_assembly/ \;

#Starting DiscovarDeNovo
DiscovarDeNovo READS=$1,$2 OUT_DIR=$3
#Move result to output folder
find . -name '*.lines.fasta' -exec mv {} outputs_assembly/ \;

#Starting masurca
# Make config-file
cat >> config-file.txt <<- EOT
# Config file for MaSurCA

# First part: defining Data type (DATA)
# parameters is down on second part (PARAMETERS)

DATA
PE= pe 235 15 $1 $2
END

PARAMETERS
NUM_THREADS=15
USE_GRID=0
GRID_ENGINE=SGE
GRID_QUEUE=all.q
USE_LINKING_MATES=1
GRAPH_KMER_SIZE=auto
END
EOT

#
#
echo "creating assemble.sh file."
masurca config-file.txt
echo "Starting real assembly"
./assemble.sh

#Move result to output folder
find . -name 'final.genome.scf.fasta' -exec mv {} outputs_assembly/ \;

#Startin Mira
# Variable assigned
# Output files are: 

###
# Second step: Assembly with MIRA
###
# Make manifest-file
cat >> manifest-file.txt <<- EOT
# Manifest File for MIRA 4

# First part: defining some basic things
# We just give a name to the assembly 
# and tell MIRA it should assemble a genome de-novo in accurate mode
# As special parameters, we want to use 40 threads in parallel

project = $3
job = genome,denovo,accurate
parameters = --hirep_good -GE:not=15 -NW:cac=warn -NW:cmrnl=no 

# The second part defines the sequencing data MIRA should load and assemble
# The data is logically divided into "readgroups

#Defining the single-end Illumina reads
readgroup = SomePairedEndIlluminaReads
data = $1 $2
technology = solexa
template_size = 300 1000 autorefine
segment_placement = ---> <---
segment_naming = solexa
EOT

#
#
echo "Starting assembly..."
mira manifest-file.txt
echo "Finished assembly\n"

#Move result to output folder
find . -name '*.unpadded.fasta' -exec mv {} outputs_assembly/ \;

#Starting Spades
spades -1 $1 -2 $2 -m 150 -t 40 -k 21,33,55,77,99,113,121,127 -o $3

#Move result to output folder
find . -name '*.scaffolds.fasta' -exec mv {} outputs_assembly/ \;

