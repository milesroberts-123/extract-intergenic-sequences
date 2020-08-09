#Examine each adjacent pair of genes, identify if their directions of transcription oppose one another
#Start iterating at chromosome level to avoid compairing genes on different chromsomes
extract_intergen = function(input, output){

gff = read.delim(input, header = F, sep = "\t")

#Subset only genes for simplicity, create random gene ids
gff = gff[which(gff$V3 == "gene"), ]
head(gff)
nrow(gff)
ids = sample(1:nrow(gff), size = nrow(gff), replace = FALSE)

#Convert some columns to character columns to avoid dealing with factors
gff$V2 = as.character(gff$V2)
gff$V9 = as.character(gff$V9)

#Iterate through each chromosome
i = 1
for(chrom in unique(gff$V1)){
	#Calculate number of adjacent gene pairs on chromosome
	gffsub = gff[which(gff$V1 == chrom),]
	row.names(gffsub) = 1:nrow(gffsub)
	pairs = floor(nrow(gffsub)/2)

	#Iterate through each gene pair on chromosome
	for(pair in 1:pairs){
		gffsubsub = gffsub[c(pair, pair+1),]
		strands = gffsubsub[,"V7"]
		#If no intergenic region is added, then result will just be the first geneic region		
		result = gffsubsub[1,]

		#If adjacent gene models are overlapping, skip looking for an intergenic region
		end1 = result[,"V5"]
		start2 = gffsubsub[2,"V4"]

		if(start2 <= end1){
			next
		}

		#If itergenic region contains opposing transcription directions, add it to gff file so that
		#is omitted from sequences later when using bedtools complement
		if(all(strands == c("-", "+")) == TRUE){
			start = gffsub[pair, "V5"] + 1
			end = gffsub[pair+1, "V4"] - 1
			intergen = c(chrom, "placeholder", "gene", start, end, ".", "+", ".", paste("ID=", ids[i], sep = ""))
			result = rbind(gffsubsub[1,], intergen)
			i = i + 1
		}

		#Append result to new gff file
		write.table(result, output, sep = "\t", append = T, quote = F, row.names = F, col.names = F)
	}

	#If there are an odd number of gene entries on the chromosome, save the last gene entry after 
	#iterating through all pairs
	if(nrow(gffsub) %% 2 == 1){
		write.table(gffsub[nrow(gffsub),], output, sep = "\t", append = T, quote = F, row.names = F, col.names = F)
	}
}

}

#Extract intergenic regions
extract_intergen(input = "notags_sorted.gff", output = "notags_sorted_filled.gff")
