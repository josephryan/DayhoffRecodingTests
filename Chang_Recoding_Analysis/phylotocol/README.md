# PLANNED ANALYSES FOR TESTING DAYHOFF RECODING  
 Principle Investigator: Joseph Ryan <br />
 Support Personnel: Alexandra Hernandez <br />
 Draft or Version Number: v.1.0 <br />
 Date: 20 Dec 2017 <br />
 Note: this document will be updated (updates will be tracked through github)
 
## 1 INTRODUCTION: BACKGROUND INFORMATION AND SCIENTIFIC RATIONALE  

### 1.1 _Background Information_  
Dayhoff (or PAM) matrices are substitution matrices used to score amino acid substitutions in sequence alignment or phylogenetic analyses. Recently, Dayhoff-6 recoding has surfaced as a technique aimed to reduce substitution saturation and compositional heterogeneity that occurs when exploring distant phylogenetic relationships. Dayhoff recoding will recode amino acids from Dayhoff matrices according to six groups of chemically related amino acids that frequently replace one another (Hrdy et al. 2005).

### 1.2 _Rationale_ 
While the principle of using Dayhoff-6 recoding is to address issues of substitution saturation and compositional bias, it assumes that patterns of substitution are the same across a sequence, and thus removes data that may be important for these analyses. Furthermore, it has never been tested to see if it does in fact improve phylogenetic reconstruction.

### 1.3 _Objectives_ 
The objective of this analysis is to test the performance of Dayhoff-6 recoding under favorable conditions and determine if it is appropriate for deep phylogenetic questions. To do this we will perform simulations to evaluate the effect of using different models (i.e., PAM250, Dayhoff-6 recoding, LG, and the best fit model) using the dataset from Chang et al. (2015) as a starting set. We will use the PAM250 model (the matrix from on which Dayhoff-6 recoding is based) for all simulations.


If Dayhoff-6 recoding consistently produces suboptimal topologies, even with high levels of genic evolution, it would raise major doubts as to the usefulness of this approach.

## 2 STUDY DESIGN AND ENDPOINTS

#### 2.1 To generate suboptimal trees for comparision purposes, we will perform rapid bootstrap analyses using the PAM250 and LG models on the Chang et al. (2015) dataset and the Chang et al. (2015) Dayhoff-recoded dataset from Feuda et al. (2017).

_RAxML (Stamatakis 2014)_

```raxmlHPC -f a -x 420 -p 420 -N 1000 -m PROTGAMMALG -s Chang_AA.phy –n Chang_LG```

```raxmlHPC -f a -x 420 -p 420 -N 1000 -m PROTGAMMADAYHOFF -s Chang_AA.phy –n Chang_dayhoff```

#### 2.2 Simulate the evolution of amino acids along the phylogeny produced in Chang et al. (2015) using the PAM model (i.e. PAM250, the model which Dayhoff-6 decoding is based) and different intervals of branch lengths (units of substitutions per site). Scale branch length = 0.5, 1, 1.5, 2, 2.5, 3

_Seq-Gen (Rambaut & Grassly 1997)_

```seq-gen –m PAM –n 1000 –s [branch length] –a 1.0 <[tree file]> Chang_seqgen.phy```

#### 2.3 Generate maximum-likelihood trees for simulated sequences using the models PAM250, Dayhoff-6 recoding, LG, and the best fit model. 

_RAxML_

2.3a Perform maximum-likelihood analysis using the PAM250 model.

```raxmlHPC –p 420 –m PROTGAMMADAYHOFF –s Chang_seqgen.phy –n Chang_seqgen_dayhoff```

2.3b We will covert sequences to a dayhoff-6 recoded dataset using the script dayhoff6decode_fasta.pl and perform a maximum-likelihood analysis using RAxML’s MULTIGAMMA multi-state model with GTR.

```perl dayhoff6decode_fasta.pl Chang_seqgen.fa > Chang_seqgen_dayhoff6.fa```

``` raxmlHPC –p 420 –m MULTIGAMMA –K GTR –s Chang_seqgen_dayhoff6.phy –n Chang_seqgen_dayhoff6```

2.3c Perform a maximum-likelihood analysis using the LG model.

```raxmlHPC –p 420 –m PROTGAMMALG –s Chang_seqgen.phy –n Chang_seqgen_LG```

2.3d Perform a maximum-likelihood analysis using the best fit model.

```raxmlHPC –p 420 –m PROTGAMMAAUTO –s Chang_seqgen.phy –n Chang_seqgen_bestfit```

#### 2.4 Repeat steps 2.2-2.3 to simulate the evolution of amino acids along the phylogeny produced in Feuda et al. (2017) and generate maximum-likelihood trees for each of the simulated alignments.

#### 2.5 Combine each of the four phylogenetic reconstructions from 2.3.1 - 2.3.4 into one treefile along with the true tree used for simulation, as well as the suboptimal bootstraps trees generated in 2.1. Then run an approximately unbiased (AU) test on all of these trees given the simulated dataset.

_CONSEL (Shimodaira & Hasegawa 2001)_

```cat Chang_tree RAxML_best.Chang_seqgen_dayhoff RAxML_best.Chang_seqgen_dayhoff6 RAxML_best.Chang_seqgen_LG RAxML_best.Chang_seqgen_bestfit RAxML_bootstrap.Chang_LG >> 105trees.tre```

```seqmt --puzzle RAxML_perSiteLLs.104trees```

```makermt RAxML_perSiteLLs```

```consel RAxML_perSiteLLs```

```catpv RAxML_perSiteLLs > out.au```

#### 2.6 AU Scoring
We will score trees based on their rank and p-value generated from the AU test. For rank scores we will simply add ranks for all simulations. We will consider models with lower rank scores to be better. For p-value scores we will simply add p-values for each test. In this case, p-value scores that are higher will indicate better models. We will perform these rankings for each of the models and present these data as support for or against Dayhoff-6 recoding. 

## 3 WORK COMPLETED SO FAR WITH DATES 
18 December 2017- We started step 2.1 (suboptimal tree generation using bootstraps) prior to the release of phylotocol version 1.0, but did not examine the results. 

## 4 LITERATURE REFERENCED  
Chang, E. S., Neuhof, M., Rubinstein, N. D., Diamant, A., Philippe, H., Huchon, D., & Cartwright, P. (2015). Genoinsights into the evolutionary origin of Myxozoa within Cnidaria. Proceedings of the National Academy of Sciences of the United States of America, 112(48), 14912–7. 

Feuda, R., Dohrmann, M., Pett, W., Philippe, H., Rota-Stabelli, O., Lartillot, N., Wörheide, G., Pisani, D. (2017). Improved Modeling of Compositional Heterogeneity Supports Sponges as Sister to All Other Animals. Current Biology, 27, 3864–3870.

Hrdy, I., Hirt, R. P., Dolezal, P., Bardonová, L., Foster, P. G., Tachezy, J., & Martin Embley, T. (2004). Trichomonas hydrogenosomes contain the NADH dehydrogenase module of mitochondrial complex I. Nature, 432, 618–622.

Rambaut A, Grassly NC. 1997. Seq-Gen: An application for the Monte Carlo simulation of DNA sequence evolution along phylogenetic trees. Computer Applications in the Biosciences, 13(3), 235–238.

Shimodaira, H., & Hasegawa, M. (2001). CONSEL: for assessing the confidence of phylogenetic tree selection. BIOINFORMATICS APPLICATIONS NOTE, 17(12), 1246–1247.

Stamatakis, A. (2014) RAxML Version 8: A tool for phylogenetic analysis and post-analysis of large phylogenies. Bioinformatics, 30, 1312–1313.
