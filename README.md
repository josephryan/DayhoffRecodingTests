# DayhoffRecodingTests
exploration of dayhoff recoding

## Can Dayhoff recoding be justified?

### What is Dayhoff recoding

Dayhoff recoding is the process of recoding each amino acid in a protein alignment according to 6 "Dayhoff" groups of chemically related amino acids that commonly replace one another (Hrdy et al. 2004). It is used to reduce the effects of substitution saturation and compositional heterogeneity. It has been used in more than 40 studies for a range of phylogenetic analyses (e.g. plants, animals, bacteria). 

### How are Dayhoff recodings derived?

Dayhoff recodings are loosely based on Dayhoff matrices (AKA PAM matrices), but I am aware of no paper explaining how they were derived. The PAM1 matrix is the only matrix emperically determined from very closely related proteins. The underlying mutation data was then extrapolated to matrices that can be used for greater distances. The PAM250 is the matrix used for the DayHoff recoding. Other matrices for example BLOSUM were derived from sequence alignments of various divergence (rather than derived). These matrices are the defaults for programs like BLAST. See Pearson 2013 for a detailed discussion. Importantly, none of these matrices are a one-size fits all.

### Are Dayhoff recodings the best possible approach?

The rationale for applying recodings is sound in principle, but it is unclear why recoding would be preferred over applying a CAT model, which is specifically designed to address the same issue and does so in a probabilistic framework. Furthermore, it is unclear why DayHoff (PAM25O) and why 6 categories.

To address this question, I explored building 6 categories of equal size as the Dayhoff recodings (i.e. 5, 4, 4, 3, 3, 1) to see if I could build recodings that scored better than the one in common use (i.e. ASTGP, DNEQ, RKH, MVIL, FYW and C). To do this I considered all the protein scoring matrices available in BLAST (ftp://ftp.ncbi.nih.gov/blast/matrices/). This included BLOSUM as well as PAM matrices.  I scored them by adding each combination in each category according to the particular matrix.  Higher scores were better.

### FINDINGS

For each matrix, I used a semi-exaustive method to construct the best set of recodings that I could assemble and then compared the score of these recodings to the commonly used Dayhoff recodings. In 34 of 69 matrices tested, my semi-exaustive method produced better scores than the Dayhoff codings. In 20 of the remaining 35 cases, I produced alternative recodings that scored equally well as the Dayhoff recodings, of wich 12 were different than the standard Dayhoff recoding. This means only 23 out of 69 matrices was Dayhoff encoding unequivically the clear best choice for encoding.

### IMPLICATIONS

If the matrices where the DayHoff recodings outperformed my custom recodings are appropriate for the dataset under analysis, than perhaps recoding could be justified, but if the matrix is not appropriate than the standard recoding is not appropriate.  However, in the case of large concatenated datasets, it seems almost certain that a single scoring matrix would be insufficient to justify across an entire alignment. Further, it is counter-intuitive to apply such a drastic step as recoding uniformly across a large multi-partitioned phylgeonomic matrix and then apply a hyper-site-specific model like CAT+GTR+Г4 to the data.

### CONCLUSION

For the reasons stated above, I argue that Dayhoff recoding should be used with caution. Given that 19/20 amino acids are affected by the application of Dayhoff recoding, it is almost certain to give alternative topologies when applied to large difficult datasets. Given all of the uncertainty surrounding Dayhoff recoding (ie. the choice of matrix, the affect of different matrices on the codings, the availability of probabilistic methods that address the problem) I don't see a strong case for applying Dayhoff recoding.

### FILES 

cluster_6catdims.pl - script that searches for alternative recodings using 69 matrices.  (requires Algorithm::Combinatorics  
http://search.cpan.org/~fxn/Algorithm-Combinatorics/

cluster_6catdims.csv - output of cluster_6catdims.pl

matrices - directory of matrices downloaded from ftp://ftp.ncbi.nih.gov/blast/matrices/ on Fri Oct 13 04:17:45 EDT 2017

### References

Hrdy I, Hirt RP, Dolezal P, Bardonová L, Foster PG, Tachezy J, Embley TM. Trichomonas hydrogenosomes contain the NADH dehydrogenase module of mitochondrial complex I. Nature. 2004 Dec 2;432(7017):618-22.

Pearson WR. Selecting the right similarity‐scoring matrix. Current protocols in bioinformatics. 2013 Oct 9:3-5.

