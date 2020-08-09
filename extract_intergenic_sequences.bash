#!/bin/bash
while getopts g:f:o: option; do
		case "${option}" in
			g) GFF=${OPTARG};;
			f) FASTA=${OPTARG};;
			o) OUTPUT=${OPTARG};;
		esac
	done

echo Intergenic regions will be extracted from $FASTA using coordinates listed in $GFF and then saved to $OUTPUT.

#Remove hashtags from gff, then the empty lines that result, and finally sort by coordinates
echo Formatting gff file for input into R...
sed 's/#.*//g' $GFF > notags.gff
sed -i '/^[[:space:]]*$/d' notags.gff

bedtools sort -i notags.gff > notags_sorted.gff

#To gff file, add "gene" features as placeholders in regions where adjacent gene models have opposing directions of transcription
echo Adding placeholders to gff file, which may take a minute...
Rscript add_placeholders_to_gff.R

#Generate genome file for bedtools (i.e. tsv file of chromosome lengths)
echo Generating list of chromosome lengths...
python3 build_genome_file.py $FASTA

#Replace commas with tabs in genome file
sed -i 's/,/\t/g' genome.txt
dos2unix genome.txt
echo Conversion done.

#Extract coordinates of all regions not listed in gff file
echo Extracting coordinates of intergenic regions...
bedtools complement -i notags_sorted_filled.gff -g genome.txt > com.gff

#Use coordinates from previous step to build fasta file
echo Creating fasta file of intergenic sequences...
bedtools getfasta -bed com.gff -fi $FASTA -fo $OUTPUT

#Clean up
echo Removing some temporary files...
rm notags.gff
rm notags_sorted.gff
rm com.gff
rm genome.txt
rm notags_sorted_filled.gff

echo "Done. Intergenic regions saved to $OUTPUT"
