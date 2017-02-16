#MOLGENIS nodes=1 ppn=1 mem=10gb walltime=05:00:00
#Parameter mapping
#string intermediateDir
#string externalSampleID
#string sampleLanesMergedBam
#string rsemIndex
#string project
#string groupname
#string tmpName
#string stage
#string checkStage
#string tempDir
#string tmpDataDir


#Load module
module load RSEM/1.2.26-foss-2015b
module list

makeTmpDir ${intermediateDir}
tmpIntermediateDir=${MC_tmpFile}

echo "## "$(date)" Start $0"
echo "ID (project-internalSampleID): ${project}-${externalSampleID}"

uniqueID="${project}-${externalSampleID}"

echo "RSEM for ScRNA"
 	
rsem-calculate-expression -p 8 \
--bam ${sampleLanesMergedBam} \
${rsemIndex} \
--no-bam-output \
${intermediateDir}/${uniqueID}.rsem

echo "## "$(date)" ##  $0 Done "
