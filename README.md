# extract-intergenic-sequences
Extract intergenic sequences from a fasta file using coordinates in a gff file, but omit intergenic sequences where adjacent genes have opposing directions of transcription.

**INPUT**
1. a fasta-formatted sequence file
2. a genome feature format (gff) file

**OUTPUT**

## USAGE
Download the three scripts in this repository and put them all in the same directory as the fasta file and gff file you want to extract intergenic sequences from. Make sure
you make all three of these scripts executable with:
`chmod +x extract_intergenic_sequences.bash`

`chmod +x build_genome_file.py`

`chmod +x subset_gene_features.R`

To extract promoter sequences, use:

`./extract_prom_seq.bash -f <FASTA FILE> -g <GFF FILE> -o <OUTPUT file name>
