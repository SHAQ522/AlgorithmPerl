#
#===============================================================================
#
#         FILE: BinaryTree.pm
#
#  DESCRIPTION: the implement of binary tree for perl
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: SHAQ (522), lsw_hehe@qq.com
# ORGANIZATION: WHU
#      VERSION: 1.0
#      CREATED: 2015年12月19日 14时20分41秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use v5.10;
 

#===  FUNCTION  ================================================================
#         NAME: ($link, $node) = basic_tree_find(\$tree,$target,$cmp)
#      PURPOSE: Search the tree \$tree for $target
#   PARAMETERS: \$tree, $target, $cmp
#      RETURNS: $link(reference to the link) $node
#  DESCRIPTION: the optional $cmp argument specifies an alternative comparison routine to be used instead of the default comparison
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================


sub basic_tree_find {
    my	($tree_link,$target,$cmp)	= @_;
    my  $node;


    while ( $node = $$tree_link ) {
        local $^W = 0;
        my  $relation = ( defined $cmp 
            ? $cmp->($target, $node->{val})
            : $target <=> $node->{val} 
        );
        return ($tree_link, $node) if $relation == 0;
        $tree_link = $relation > 0 ? \$node->{left} : \$node->{right};
    }
    return ($tree_link,undef);
} ## --- end sub basic_tree_find

#===  FUNCTION  ================================================================
#         NAME: basic_tree_add
#      PURPOSE: if there is not already a node in the tree, create one. 
#   PARAMETERS: $tree_link, $target, $cmp
#      RETURNS: the new or previously existing node
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub basic_tree_add {
    my	( $tree_link, $target, $cmp )	= @_;
    my  $found;

    ($tree_link, $found) = basic_tree_find($tree_link, $target, $cmp);

    
    unless ( $found ) {
        $found = {
            left  => undef,
            right => undef,
            val   => $target,
        };
        $$tree_link = $found; # :TODO:2015年12月19日 14时55分55秒:522: Where is previous data
    }

    return $found;
} ## --- end sub basic_tree_add

#===  FUNCTION  ================================================================
#         NAME: basic_tree_del
#      PURPOSE: Find the element of \$tree and remove it from the tree
#   PARAMETERS: $tree_link, $target, $cmp
#      RETURNS: return the value or undef if there was no appropriate element
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub basic_tree_del {
    my	( $tree_link, $target, $cmp )	= @_;
    my  $found;

    ($tree_link, $found) = basic_tree_find($tree_link, $target, $cmp);

    return undef unless $found;

   
    if ( ! defined $found->{left} ) {
        $$tree_link = $found->{right};
    }   elsif (! defined $found -> {right}) {
        $$tree_link = $found->{left};
    }
    else {
        MERGE_SOMEHOW($tree_link, $found);
    }

    return $found->{val};
} ## --- end sub basic_tree_del


#===  FUNCTION  ================================================================
#         NAME: MERGE_SOMEHOW
#      PURPOSE: Make $tree_link point to both $found->{left} and $found->{right}
#   PARAMETERS: $tree_link, $found
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub MERGE_SOMEHOW {
    my	( $tree_link, $found )	= @_;
    my  $left_of_right = $found->{right};
    my  $next_left;
    $left_of_right = $next_left 
        while $next_left = $left_of_right->{left};
    $left_of_right->{left} = $found->{left};
    $$tree_link = $found->{left};
} ## --- end sub MERGE_SOMEHOW


#===  FUNCTION  ================================================================
#         NAME: basic_show_nodes
#      PURPOSE: to show all the elements of the tree
#   PARAMETERS: $tree_link
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub basic_show_nodes {
    my	( $tree_link )	= @_;
    my  @list;
    my  @vals;
    my $node = $$tree_link;

    push @list , $node;


    while ( $node = pop @list ) {
        push(@list , $node->{left})  if $node->{left};
        push(@list , $node->{right}) if $node->{right} ;
        push @vals , $node->{val};
    }

    say "@vals";
    return ;
} ## --- end sub basic_show_nodes


#===  FUNCTION  ================================================================
#         NAME: traverse
#      PURPOSE: Traverse tree in order calling func()
#   PARAMETERS: $tree, $func
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub traverse {
    my	$tree = shift or return;
    my  $func = shift;

    traverse(tree->{left}, $func);
    &$func($tree);
    traverse(tree->{right}, $func);

    return ;
} ## --- end sub traverse

my $tree = {
            left  => undef,
            right => undef,
            val => 10,
} ;

basic_tree_add(\$tree,4);
basic_show_nodes(\$tree);
basic_tree_add(\$tree,5);
basic_show_nodes(\$tree);
basic_tree_add(\$tree,2);
basic_show_nodes(\$tree);
basic_tree_add(\$tree,7);
basic_show_nodes(\$tree);
basic_tree_add(\$tree,8);
basic_show_nodes(\$tree);
basic_tree_del(\$tree,2);
basic_show_nodes(\$tree);

