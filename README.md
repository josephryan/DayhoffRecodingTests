# DayhoffRecodingTests
exploration of dayhoff recoding

## Can Dayhoff recoding be justified?

### What is Dayhoff recoding

Dayhoff recoding is the process of recoding each amino acid in a protein alignment according to 6 "Dayhoff" groups of chemically related amino acids that commonly replace one another (Embley et al. 2003; Hrdy et al. 2004; Susko et al. 2007). It is used to reduce the effects of substitution saturation and compositional heterogeneity. It has been used in more than 40 studies for a range of phylogenetic analyses (e.g. plants, animals, bacteria). 

### How are Dayhoff recodings derived?

Dayhoff recodings are loosely based on Dayhoff matrices (AKA PAM matrices). The six classes were obtained from a log odds matrix of probabilities of pairs of amino acids appearing together; the exception being the G and P in the group AGPST (Susko et al. 2007). The PAM1 matrix is the only matrix (of the PAM matrices) emperically determined from very closely related proteins. The underlying mutation data was then extrapolated to matrices that can be used for greater distances. The PAM250 is the matrix used for the DayHoff recoding. Other matrices for example BLOSUM were derived from sequence alignments of various divergence (rather than derived). These matrices are the defaults for programs like BLAST. See Pearson 2013 for a detailed discussion. Importantly, none of these matrices are a one-size fits all.

### Are Dayhoff recodings the best possible approach?

The rationale for applying recodings is sound in principle, but it is unclear why recoding would be preferred over applying a CAT model, which is specifically designed to address the same issues and does so in a probabilistic framework. 

To understand the variation of groups when different matrices were applied, I explored building 6 categories of equal size as the Dayhoff recodings (i.e. 5, 4, 4, 3, 3, 1) to see if I could build recodings that scored better than the one in common use (i.e. ASTGP, DNEQ, RKH, MVIL, FYW and C). To do this I considered all the protein scoring matrices available in BLAST (ftp://ftp.ncbi.nih.gov/blast/matrices/). This included BLOSUM as well as PAM matrices.  I scored them by adding each combination in each category according to the particular matrix.  Higher scores were better.

### FINDINGS

For each matrix, I used a semi-exaustive method to construct the best set of recodings that I could assemble and then compared the score of these recodings to the commonly used Dayhoff recodings. In 34 of 69 matrices tested, my semi-exaustive method produced better scores than the Dayhoff codings. In 20 of the remaining 35 cases, I produced alternative recodings that scored equally well as the Dayhoff recodings, of wich 12 were different than the standard Dayhoff recoding. 

### IMPLICATIONS

If the matrices where the DayHoff recodings outperformed my custom recodings are appropriate for the dataset under analysis, than perhaps recoding could be justified, but if the matrix is not appropriate than the standard recoding is not appropriate.  However, in the case of large concatenated datasets, it seems almost certain that a single scoring matrix would be insufficient to justify across an entire alignment. Further, it is counter-intuitive to apply such a drastic step as recoding uniformly across a large multi-partitioned phylgeonomic matrix and then apply a hyper-site-specific model like CAT+GTR+Г4 to the data.

### ALTERNATIVE RECODING APPROACHES

If recoding is insisted upon, wouldn't it make more sense to code each column based on the matrix corresponding to the percent identity of that column? I have run some analyses applying qt clustering to determining number and size of clusters, but it still requires determining a threshold. Even so, I was unable to apply a threshold that gave me the structure in the Dayhoff recoding scheme. QT clustering (which is a greedy algorithm by nature) usually ended up w one or two large clusters and a bunch of singlets, which might be more appropriate. 

## SIMULATIONS TO ADDRESS WHETHER RECODING ADDRESSES SATURATION?

We are in the process of performing the following simulations to test the performance of Dayhoff-6 recoding under favorable conditions and determine if it is appropriate for deep phylogenetic questions. On two separate trees that that include a wide range of animals and opisthokont outgroups, we simulate 1,000 datasets of 1,000 amino-acids under the Dayhoff250 model of evolution. In total, we simulate 20 such data sets for each tree, incrementing the branch length scaling factor for each set by one (up to 20). The increase in scaling factor corresponds with an increase in saturation and therefore allows us to determine the effectiveness of Dayhoff recoding on counteracting the effects of sauturation. For each dataset we produced a tree that used the Dayhoff250 matrix and one that used Dayhoff recoding. **If recoding is beneficial in cases of high saturation, at some level of saturation, trees based on recoded data should be more accurate  than those solved with a non-recoded matrix.** Our preliminary results produced with Dayhoff recoding were consistently suboptimal to those produced with the Dayhoff 250 matrix in terms of split distances as implemented in TOPD (Puigbò et al. 2007). Our preliminary results which we presented at the 2018 meeting of the Society of Integrative and Comparative Biology suggest that Dayhoff recoding does not improve the accuracy of phylogenetic reconstruction and that results based on this scheme should be reevaluated. We will post the final results here as soon as they are available.

### FILES 

cluster_6catdims.pl - script that searches for alternative recodings using 69 matrices.  (requires Algorithm::Combinatorics  
http://search.cpan.org/~fxn/Algorithm-Combinatorics/

cluster_6catdims.csv - output of cluster_6catdims.pl

matrices - directory of matrices downloaded from ftp://ftp.ncbi.nih.gov/blast/matrices/ on Fri Oct 13 04:17:45 EDT 2017

### References

Embley M, Van Der Giezen M, Horner DS, Dyal PL, Foster P. Mitochondria and hydrogenosomes are two forms of the same fundamental organelle. Philosophical Transactions of the Royal Society B: Biological Sciences. 2003 Jan 29;358(1429):191-203.

Hrdy I, Hirt RP, Dolezal P, Bardonová L, Foster PG, Tachezy J, Embley TM. Trichomonas hydrogenosomes contain the NADH dehydrogenase module of mitochondrial complex I. Nature. 2004 Dec 2;432(7017):618-22.

Pearson WR. Selecting the right similarity‐scoring matrix. Current protocols in bioinformatics. 2013 Oct 9:3-5.

Puigbò P, Garcia-Vallvé S, McInerney JO. TOPD/FMTS: a new software to compare phylogenetic trees. Bioinformatics. 2007 Apr 25;23(12):1556-8.

Susko E, Roger AJ. On reduced amino acid alphabets for phylogenetic inference. Molecular biology and evolution. 2007 Jul 25;24(9):2139-50.
