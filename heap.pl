#!/usr/bin/env perl
#===============================================================================
#
#         FILE: heap.pl
#
#        USAGE: ./heap.pl  
#
#  DESCRIPTION: the implement of the heap
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: SHAQ (522), lsw_hehe@qq.com
# ORGANIZATION: WHU
#      VERSION: 1.0
#      CREATED: 12/21/15 22:03:27
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use v5.10;
use utf8;


#===  FUNCTION  ================================================================
#         NAME: heapup
#      PURPOSE: carries out the upward adjustment 
#   PARAMETERS: \@array and $index which needs to adjust
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================


sub heapup {
    my	( $array, $index )	= @_;
    my  $value = $array->[$index];


    while ( $index ) {
        my  $parent = int( ($index - 1)/2 );
        my  $pv = $array->[$parent];
        last if $pv lt $value;
        $array->[$index] = $pv;
        $index = $parent;
    }
    $array->[$index] = $value;

} ## --- end sub heapup


#===  FUNCTION  ================================================================
#         NAME: heapdown
#      PURPOSE: carries out the down adjustment
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub heapdown {
    my	( $array, $index ,$last )	= @_;
    defined($last) or $last = $#$array;

    return if $last <= 0;

    my $value = $array->[$index];

    while($index < $last){
        my $child = $index * 2 + 1;
        last if $child > $last;
        my $cv = $array->[$child];
        if($child < $last){
            my $cv2 = $array->[$child+1];
            if($cv2 lt $cv){
                $cv = $cv2;
                ++$child;
            }
        }
        last if $value le $cv;
        $array->[$index] = $cv;
        $index = $child;
    }
    $array->[$index] = $value;

    return ;
} ## --- end sub heapdown


#===  FUNCTION  ================================================================
#         NAME: heapify
#      PURPOSE: make an array to be a heap
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub heapify_array_up {
    my	( $array )	= @_;

    for ( my $i = 1; $i < @$array ; ++$i  ) {
        heapup($array, $i);
    }
} ## --- end sub heapify_array_up


sub heapify_array_down {
    my	( $array )	= @_;
    my $last = $#$array;

    for ( my $i = int(($last-1)/2); $i>=0 ; --$i ) {
        heapdown($array,$i,$last);
    }
} ## --- end sub heapify_array_down


sub extract {
    my	( $array , $last )	= @_;
    defined($last) or $last = $#$array;

    return undef if $last < 0;

    return pop(@$array) unless $last;

    my $value = $array->[0];

    $array->[0] = $array->[$last];

    heapdown($array,0,$last);

    return $value;
} ## --- end sub extract



sub sortheap {
    my	( $array )	= @_;


    for ( my $i = $#$array; $i; ) {
        @$array[0,$i] = @$array[$i,0];
        heapdown($array,0,--$i);
    }
} ## --- end sub sortheap

my @array = qw(d e t f q x a);
heapify_array_down(\@array);
sortheap(\@array);
say "@array";
