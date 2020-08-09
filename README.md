# extract-intergenic-sequences
This code will extract intergenic sequences from a fasta file using coordinates in a gff file, but omit intergenic sequences where the adjacent genes have opposing directions of transcription. Such sequences may be useful background sequences for some bioinformatic analyses, such as *de novo* motif discovery.

This code was inspired by guidelines for using [MotifSuite](http://bioinformatics.intec.ugent.be/MotifSuite/usecreatebackgroundmodel.php), a set of executables for *de novo* motif discovery.

**INPUT**
1. a fasta-formatted sequence file
2. a genome feature format (gff) file

**OUTPUT**

A fasta-formatted sequence file where each entry is an intergenic sequence (i.e. a sequence lying between two genes). 

## USAGE

Download the three scripts in this repository and put them all in the same directory as the fasta file and gff file you want to extract intergenic sequences from. Make sure
you make all three of these scripts executable with:

`chmod +x extract_intergenic_sequences.bash`

`chmod +x build_genome_file.py`

`chmod +x add_placeholders_to_gff.R`

To extract promoter sequences, use:

`./extract_intergenic_sequences.bash -f <FASTA FILE> -g <GFF FILE> -o <OUTPUT file name>`

## EXPLANATION

An intergenic region where the directions of transcription are as so:

<pre>

gene 1 transcription =>
5'====================================================================================3'
3'====================================================================================5'
                                                                <= gene 2 transcription 

</pre>

is not likely to contain some types of regulatory sequences, such as those often found in promoters, because it contains no sequence upstream of gene's transcription start site. However, these three other types of intergenic regions do often contain regulatory sequences:

<pre>

gene 1 transcription =>                                         gene 2 transcription =>
5'====================================================================================3'
3'====================================================================================5'

                                                                      
5'====================================================================================3'
3'====================================================================================5'
<= gene 1 transcription                                         <= gene 2 transcription
       
       
                                                                gene 2 transcription =>     
5'====================================================================================3'
3'====================================================================================5'
<= gene 1 transcription 

</pre>

The code published here will omit intergenic regions from a set of sequences, but omit sequences of the first type above from the final output.

## DEPENDENCIES

1. bedtools

Installation instructions are [here](https://bedtools.readthedocs.io/en/latest/content/installation.html)

2. base R

I tested this with R 3.6

3. Biopython

Installation instructions are [here](https://biopython.org/wiki/Download)

4. dos2unix (maybe optional, but I need to do more testing)

Install with:

`sudo apt install dos2unix`
