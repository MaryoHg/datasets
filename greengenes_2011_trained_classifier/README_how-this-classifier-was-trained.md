# 1. Download and decompress the Green-genes database from qiime2 documentation

```
# Download the tar-compress green-genes database
wget -c http://greengenes.lbl.gov/Download/Sequence_Data/Fasta_data_files/Caporaso_Reference_OTUs/gg_otus_4feb2011.tgz

# decompress
tar -xvzf -C $HOME/Desktop/metabaR/qiime2 ./gg_otus_4feb2011.tgz			# `-C` option indicate output dir
```

# 2. Load sequences and taxonomy of gg-2011 and create the qiime2 artificts

```
# create output dir
mkdir db

# a. import sequences to an artifact
qiime tools import \
--type 'FeatureData[Sequence]' \
--input-path gg_otus_4feb2011/rep_set/gg_97_otus_4feb2011.fasta \
--output-path ./db/97_otus.fasta.qza

# b. Import taxonomy to an artifact
qiime tools import \
--type 'FeatureData[Taxonomy]' \
--input-format HeaderlessTSVTaxonomyFormat \
--input-path gg_otus_4feb2011/taxonomies/greengenes_tax.txt \
--output-path db/taxonomy-ref.qza

```

# 3. Filtering the database based on the primers used during amplification

Sequences of primers used, i.e., V3-V4, are required in this process.

```
qiime feature-classifier extract-reads \
--i-sequences db/97_otus.fasta.qza \
--p-f-primer CCTACGGGNGGCWGCAG \
--p-r-primer GACTACHVGGGTATCTAATCC \
--p-min-length 300 \ 						# min read length size to filter from db
--p-max-length 500 \						# max read length size to filter from db
--o-reads db/gg_selected_seqs.qza \
--p-n-jobs 4							# use the total number of cores of CPU; $nproc to count

```

# 4. Trained the Naive-Bayes classifier with the filtered database

```
qiime feature-classifier fit-classifier-naive-bayes \
--i-reference-reads db/gg_selected_seqs.qza \
--i-reference-taxonomy db/taxonomy-ref.qza \
--o-classifier db/gg_trained_classifier.qza
```

# 5. Taxonomy annotation with the trained classifier:

```
qiime feature-classifier classify-sklearn \
--i-classifier db/gg_trained_classifier.qza \			# trained classifier from the last step
--i-reads rep-seqs.qza \					# representative-sequences obtained from DADA2: rep-seqs.qza
--p-confidence 0.97 \						# confidence threhold – read the --help documentation
--o-classification taxonomy-of-our-ASVs.qza			# output file with taxonomy of our ASVs assigned.
```


