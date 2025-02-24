#!/bin/bash

# single ended sequencing, 'bam --> fastq --> bam' process 

mkdir ChIPseq
mv sequencelocation.txt ChIPseq
cd ChIPseq

wget -i sequencelocation.txt

# samtools, bedtools and bowtie are required
# module load samtools
# module load bedtools/2.25.0
# module load bowtie

for i in ENCFF834CAH ENCFF953EVD
do
        
samtools sort ${i}.bam -o ${i}.sort
samtools index ${i}.sort
samtools view -@ 10 -bhS ${i}.sort chr1 |samtools sort -n - -o ${i}.chr1.bam
bedtools bamtofastq -i ${i}.chr1.bam -fq ${i}.chr1.fq
#rm ${i}.chr1.fq.gz
#gzip ${i}.chr1.fq
#bowtie -m 1 -S ../hg38/GRCh38.chr1 ${i}.chr1.fq |samtools view -@ 10 -bhS - > ${i}.chr1.realigned.bam
#samtools sort ${i}.chr1.realigned.bam -o ${i}.chr1.realigned.sort.bam
#samtools index ${i}.chr1.realigned.sort.bam

#samtools sort ${i}.chr1.bam -o ${i}.chr1.sort.bam
#samtools index ${i}.chr1.sort.bam
done

mv ENCFF834CAH.chr1.fq GM12878_CTCF_chr1.fastq
mv ENCFF953EVD.chr1.fq GM12878_control_chr1.fastq

rm *.bam *.sort *.bai
cd ..
