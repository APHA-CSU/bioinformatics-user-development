#!/bin/bash

# Error handling
# -e instructs Bash to exit immediately if any command has a non-zero exit status
# -o pipefail instructs Bash to return the value of the last command to exit with a non-zero status
set -e -o pipefail

# Create new directories to store input and output files
mkdir -p input_files
mkdir -p output_files

# Set parameters using the Bash programming language (note: no spaces either side of "=")
PROC=4 # number of processors to use
inDIR=$PWD/input_files # set input directory
outDIR=$PWD/output_files # set output directory

echo $inDIR
echo $outDIR

# Download FASTQ reads to input_files directory
fasterq-dump --split-files --outdir $inDIR --threads $PROC SRR18391668

# Compress files
gzip $inDIR/*.fastq

# Count the number of sequences in both reads and save in a text file
zcat $inDIR/SRR18391668_1.fastq.gz | grep -c "^@SRR" > $outDIR/num_reads1.txt
zcat $inDIR/SRR18391668_2.fastq.gz | grep -c "^@SRR" > $outDIR/num_reads2.txt

# Print the read lengths in both reads and save in a text file
zcat $inDIR/SRR18391668_1.fastq.gz | grep -A 1 "^@SRR" | grep -v "^@SRR" | grep -v "^--" | awk '{print length}' > $outDIR/read_lengths1.txt
zcat $inDIR/SRR18391668_2.fastq.gz | grep -A 1 "^@SRR" | grep -v "^@SRR" | grep -v "^--" | awk '{print length}' > $outDIR/read_lengths2.txt

# Convert FASTQ to a FASTA file
zcat $inDIR/SRR18391668_1.fastq.gz | sed -n '1~4s/^@/>/p;2~4p' > $outDIR/SRR18391668_1.fa
zcat $inDIR/SRR18391668_2.fastq.gz | sed -n '1~4s/^@/>/p;2~4p' > $outDIR/SRR18391668_2.fa
