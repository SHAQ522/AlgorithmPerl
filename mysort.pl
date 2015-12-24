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


#===  FUNCTION  ================================================================
#         NAME: insertion_merge
#      PURPOSE: merge two sorted arrays into a large array
#   PARAMETERS: ????
#      RETURNS: merged array
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub insertion_merge {
    my	( $large, $small )	= @_;
    my  $merged;

    $#$merged = @$large + @$small - 1;
    
    for ( my ($i, $j, $k) = (0,0,0); $i < @$merged ; ++$i  ) {
        if($j==@$large){
            $merged->[$i] = $small->[$k++];
            next;
        }
        if($k==@$small){
            $merged->[$i] = $large->[$j++];
            next;
        }
        $merged->[$i] = $large->[$j] < $small->[$k] ? $large->[$j++] : $small->[$k++];
    }

    return $merged;
} ## --- end sub insertion_merge


#===  FUNCTION  ================================================================
#         NAME: insert_sort
#      PURPOSE: the implement of the insert sort algorithm
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub insert_sort {
    my	( $array )	= @_;

    for ( my $i = 0; $i<$#$array; ++$i  ) {
        my $pos = $i;
        my $min = $array->[$pos];
        for ( my $j = $i + 1; $j < @$array; ++$j ) {
            ($pos,$min) = ($j,$array->[$j]) if $array->[$j] < $min; 
        }
        splice @$array , $i , 0 , splice @$array , $pos , 1 if $pos > $i;
    }
} ## --- end sub insert_sort


#===  FUNCTION  ================================================================
#         NAME: heapsort
#      PURPOSE: the implement of heap sort
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub heapsort {
    my	( $array )	= @_;

    for ( my $index = int(($#$array-1)/2); $index >= 0; $index--   ) {
        heapify($array,$index);
    }

    for (my $last = $#$array;$last >=0 ; ){
        @$array[0,$last] = @$array[$last,0];
        heapify($array,0,$last--);
    }

    return ;
} ## --- end sub heapsort


sub heapify {
    my	( $array,$index,$last )	= @_;
    my $value = $array->[$index];

    $last = @$array unless defined $last;


    while ( 2*$index+1 < $last ) {
        my $child = 2*$index+1;
              if($child+1<$last){
            $child+=1 if ($array->[$child]) < ($array->[$child + 1]);
        }
        last if $value > $array->[$child];
        $array->[$index] = $array->[$child];
        $index = $child;
    }
    $array->[$index] = $value;

} ## --- end sub heapify


#-------------------------------------------------------------------------------
#  below this is test code
#-------------------------------------------------------------------------------
#my @array = (4,4,4,4,4);

#say "@array";
#election_sort(\@array);
#say "@array";
#
#
#my ($i_min, $i_max) = gextri(sub{$_[0] <=> $_[1]},\@array);
#say "@$i_min";
#say "@$i_max";
#
#my @large = qw(1 4 9 16 25 36 49 64 81 100);
#my @small = qw(2 5 11 17 23);
#my $merge = insertion_merge(\@large, \@small);
#say "@{$merge}"
#
use integer;
my  @array = qw(12 4 6 8 43 23 44 21 13 42 1 2);
say "@array";
heapsort(\@array);
say "@array";



