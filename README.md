# Genome-Assembly
## Pipeline for genome assembly with multiple assembly tools
### The script "pipeline_assembly" runs and automated pipeline for bacterial genome assembly with five (Mira, Spades, DiscovarDeNovo, A5 pipeline, Masurca) different genome assemblers. 
#### The script create a folder "outputs_assembly" where all final assemblys are stored.
#### To install each tool please refer to each documentation:
#### `MIRA` -->  https://github.com/bachev/mira
#### `Spades` --> https://github.com/ablab/spades
#### `DiscovarDeNovo` --> https://anaconda.org/bioconda/discovardenovo
#### `A5 pipeline` --> https://sourceforge.net/p/ngopt/wiki/A5PipelineREADME/
#### `Masurca` --> https://github.com/alekseyzimin/masurca
#### `Quast` --> http://quast.sourceforge.net/docs/manual.html#sec1
#### `Metassembler` --> https://github.com/biol7210-genomes/assemblers/blob/master/metassembler.md
### Python dependencies:
#### Pandas
#### Os
#### sys
### To run the script: bash pipeline_assembly /path/to/read1 /path/to/read2 prefix_for_assembly
### After all assemblys are done run the metassembler_pipeline.py python script inside the "outputs_assembly" as such: 
### python3 meatssembler_pipeline.py /path/to/read1 /path/to/read2
#### This python scripts runs Quast for all 5 assemblys and generate the Metassemble tool configuration file with all 5 assemblys sorted in order of N50 value, from higher N50 value (less fragmented genomes) to lower N50 values.
