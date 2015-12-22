#!/usr/bin/env perl
#===============================================================================
#
#         FILE: mysort.pl
#
#        USAGE: ./mysort.pl  
#
#  DESCRIPTION: the implement of sort method using perl
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: SHAQ (522), lsw_hehe@qq.com
# ORGANIZATION: WHU
#      VERSION: 1.0
#      CREATED: 12/22/15 20:48:15
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use v5.10;


#===  FUNCTION  ================================================================
#         NAME: election_sort
#      PURPOSE: the implement of the election sort algorithm
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub election_sort {
    my	( $array )	= @_;

    for ( my $i = 0; $i<$#$array; ++$i  ) {
        my $pos = $i;
        my $min = $array->[$pos];

        for ( my $j = $i+1; $j < @$array; ++$j ) {
            ($min,$pos) = ($array->[$j],$j) if $array->[$j] < $min;
        }
        @$array[$i,$pos] = @$array[$pos,$i]; 
    }
} ## --- end sub election_sort


#===  FUNCTION  ================================================================
#         NAME: generic min and max
#      PURPOSE: the implement of generic min or max function
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub gmin {
    my $g_cmp = shift;
    my $g_min = shift;
    foreach (@_){
        $g_min = $_ if $g_cmp->($_, $g_min) < 0;
    }
    return $g_min;
} ## --- end sub gmin

sub gmax {
    my $g_cmp = shift;
    my $g_max = shift;
    foreach (@_){
        $g_max = $_ if $g_cmp->($_, $g_max) > 0;
    }
    return $g_max;
} ## --- end sub gmax


#===  FUNCTION  ================================================================
#         NAME: gextri
#      PURPOSE: get the min and max indexes 
#   PARAMETERS: ????
#      RETURNS: two anonymous arrays containing the indices of the minima and maxima
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub gextri {
    my	( $cmp, $array )	= @_;
    my  $min = $array->[0];
    my  $max = $array->[0];
    my  @mini = (0);
    my  @maxi = (0);
    for ( my $i = 1; $i<=$#$array; ++$i ) {
        my $v_cmp = $cmp->($max,$array->[$i]);
        if ( $v_cmp < 0 ) {
            $max = $array->[$i];
            @maxi = ($i);
        }
        elsif ( $v_cmp == 0 ) {
            push @maxi, $i;
            push @mini, $i if $min == $max;
        }
        else {
            my $v_cmp = $cmp->($min,$array->[$i]);
            if ( $v_cmp > 0 ) {
                $min = $array->[$i];
                @mini = ($i);
            }
            elsif ($v_cmp == 0) {
                push @mini, $i ;
            }
        }
    }

    return (\@mini,\@maxi);
} ## --- end sub gextri
#

#-------------------------------------------------------------------------------
#  below this is test code
#-------------------------------------------------------------------------------
my @array = (4,4,4,4,4);

say "@array";
election_sort(\@array);
say "@array";


my ($i_min, $i_max) = gextri(sub{$_[0] <=> $_[1]},\@array);
say "@$i_min";
say "@$i_max";


