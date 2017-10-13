#!/usr/bin/perl

# requires Algorithm::Combinatorics

# this script builds best clusters of the same dimensions as 
# Dayhoff 6 category encoding: ASTGP, DNEQ, RKH, MVIL, FYW and C
# as implemented in Hrdy I, Hirt RP, Dolezal P, Bardonová L, Foster PG, Tachezy J, Embley TM. Trichomonas hydrogenosomes contain the NADH dehydrogenase module of mitochondrial complex I. Nature. 2004 Dec 2;432(7017):618-22.

use strict;
use warnings;
use Algorithm::Combinatorics;
use Data::Dumper;

# NOTE: score subroutine sets a score of -1000000 which should
#       work fine, but is a weak hack. fix maybe in future

our @SIZES    = (5,4,4,3,3,1);
our $DIR      = 'matrices';
our @DAYHOFF6 = (['A','S','T','G','P'],['D','N','E','Q'],['R','K','H'],['M','V','I','L'],['F','Y','W'],['C']);

MAIN: {
    my $ra_matrices = get_matrices($DIR);
    print "MATRIX,DAYHOFF_RECODE_SCORE,BEST_RECODE_SCORE,RECODE\n";
    foreach my $matrix (@{$ra_matrices}) {
        next if ($matrix =~ m/BLOSUM\d+\.50/);
        next if ($matrix =~ m/PAM\d+\.cdi/);
        get_size_matched_clusters($matrix);
    }
}

sub get_size_matched_clusters {
    my $matrix  = shift;
    my $iter = Algorithm::Combinatorics::permutations(\@SIZES);
    my $best;
    my $ra_cl = [];
    while (my $ra_sizes = $iter->next) {
        my $rh_dmat = get_mat($matrix);    
        my ($ra_six,$hi) = gsmc($rh_dmat,$ra_sizes);
        if (!$best || $hi > $best) {
            $best = $hi;
            $ra_cl = $ra_six;
        } # ignore ties
    }
    my $rh_dmat = get_mat($matrix);    
    my $dayhoff6 = get_dayhoff6_score($rh_dmat,\@DAYHOFF6);
    print "$matrix,$dayhoff6,$best,";
    print_clusters($ra_cl);
}

sub gsmc {
    my $rh_dmat = shift;
    my $ra_sizes = shift;
    my @sixpack = ();
    my $total = 0;
    foreach my $size (@{$ra_sizes}) {
        my @aas = keys %{$rh_dmat}; # reset @aas after deleting last size
        my $iter = Algorithm::Combinatorics::combinations(\@aas,$size);
        my $hi_sc;
        my @hi = ();
        while (my $ra_combo = $iter->next) {
            my $score = score($rh_dmat,$ra_combo);
            if (!$hi_sc || $score > $hi_sc) {
                $hi_sc = $score;
                @hi = ($ra_combo);
            } elsif ($score == $hi_sc) {
                push @hi, $ra_combo;
            }
        }
#        return if (scalar(@hi) > 1);  # we will get ties this is not optimal
#        die "unexpected" if (scalar(@hi) > 1);
        push @sixpack, $hi[0];
        $total += $hi_sc;
        remove_from_dmat($rh_dmat,$hi[0]);
    }
    return(\@sixpack,$total);
}

sub get_dayhoff6_score {
    my $rh_dmat = shift;
    my $ra_six  = shift;
    my $score   = 0;
    foreach my $ra_s (@{$ra_six}) {
        $score += score($rh_dmat,$ra_s);
    }
    return $score;
}

sub get_matrices {
    my $dir = shift;
    my @matrices = ();
    opendir DIR, $dir or die "cannot opendir $dir:$!";
    my @files = grep { !/^\./ && !/README.matrices/ } readdir DIR;    
    foreach my $f (@files) {
        push @matrices, "$dir/$f";
    }
    return \@matrices;
}

sub print_clusters {
    my $ra_clusters = shift;
    my $pr_str = '';
    
    foreach my $ra_c (@{$ra_clusters}) {
        my $str = join '', sort(@{$ra_c});
        $pr_str .= $str . ' ';
    }
    chop $pr_str; chop $pr_str;
    print "$pr_str\n";
}

sub score {
    my $rh_m = shift;
    my $ra_t = shift;
    my $score = 0;
    my %seen = ();
    foreach my $idx (@{$ra_t}) {
        foreach my $idy (@{$ra_t}) {
            next if ($idx eq $idy);
            next if ($seen{$idx}->{$idy});
            $seen{$idy}->{$idx} = 1;
            $score += $rh_m->{$idx}->{$idy};
        }
    }
    return $score;
}

sub remove_from_dmat {
    my $rh_d = shift;
    my $ra_t = shift;
    foreach my $id (@{$ra_t}) {
        delete $rh_d->{$id};
    }
}

sub get_mat {
    my $file = shift;
    my %mat  = ();
    my @aa   = ();

    open IN, $file or die "cannot open $file:$!";
    while (my $line = <IN>) {
        next if ($line =~ m/^\s*$/); # skip blanks
        next if ($line =~ m/^\s*#/); # skip comments
        next if ($line =~ m/^B/);
        next if ($line =~ m/^X/);
        next if ($line =~ m/^Z/);
        next if ($line =~ m/^\*/);
        next if ($line =~ m/^\*/);
        if ($line =~ m/^\s+\w\s+\w/) {
            $line =~ s/^\s+//;
            die "unexpected" if (@aa);
            @aa = split /\s+/, $line;
            pop @aa if ($aa[-1] eq '*');
        } elsif ($line =~ m/^\w/) {
            my @scores = split /\s+/, $line;
            my $aaa = shift @scores;
            for (my $i = 0; $i < @aa; $i++) {
                $mat{$aaa}->{$aa[$i]} = $scores[$i];
            }
        } else {
            die "unexpected line: $line\n";
        }
    }
    return \%mat;
}
