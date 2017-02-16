#MOLGENIS nodes=1 ppn=1 mem=34gb walltime=05:00:00

#Parameter mapping
#string seqType
#string lane
#string taggedUnmappedfilterFQs
#string intermediateDir
#string externalSampleID
#string project
#string groupname
#string tmpName
#string alignedSortedBam
#string starIndex
#string	starVersion

#Load module
module load ${starVersion}
module list

makeTmpDir ${intermediateDir}
tmpIntermediateDir=${MC_tmpFile}

echo "## "$(date)" Start $0"
echo "ID (project-internalSampleID-lane): ${project}-${externalSampleID}-L${lane}"

uniqueID="${project}-${externalSampleID}-L${lane}"

echo "STAR SR for ScRNA"

usedWorkflow=$(basename ${workflow})

if [ "${usedWorkflow}" == "workflow.csv" ]
then
 	
	 $EBROOTSTAR/bin/STAR \
	--genomeDir ${starIndex} \
	--runThreadN 2 \
	--readFilesIn ${taggedUnmappedfilterFQs} \
	--outSAMtype BAM SortedByCoordinate \
	--twopassMode Basic \
	--limitBAMsortRAM 45000000000 \
	--outFileNamePrefix ${tmpIntermediateDir}/${uniqueID}.bam

	mv ${tmpIntermediateDir}/${uniqueID}.bamAligned.sortedByCoord.out.bam ${alignedSortedBam}
	mv ${tmpIntermediateDir}/${uniqueID}.bamLog.final.out ${intermediateDir}/${uniqueID}.final.log

elif [ "${usedWorkflow}" == "workflow_RSEM.csv" ]
then
       $EBROOTSTAR/bin/STAR \
        --genomeDir ${starIndex} \
        --runThreadN 2 \
        --readFilesIn ${taggedUnmappedfilterFQs} \
        --outSAMtype BAM SortedByCoordinate \
        --twopassMode Basic \
        --limitBAMsortRAM 45000000000 \
	--quantMode TranscriptomeSAM \
        --outFileNamePrefix ${tmpIntermediateDir}/${uniqueID}.bam

	mv ${tmpIntermediateDir}/${uniqueID}.bamAligned.toTranscriptome.out.bam ${alignedSortedBam}
	mv ${tmpIntermediateDir}/${uniqueID}.bamLog.final.out ${intermediateDir}/${uniqueID}.final.log

else
	echo "${usedWorkflow} unknown"
	exit 1

fi

echo "succes moving files";
echo "## "$(date)" ##  $0 Done "
