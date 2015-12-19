#
#===============================================================================
#
#         FILE: BalancedTree.pm
#
#  DESCRIPTION: the implement of Balanced tree
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: SHAQ (522), lsw_hehe@qq.com
# ORGANIZATION: WHU
#      VERSION: 1.0
#      CREATED: 12/19/15 16:54:16
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use v5.10; 

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

    traverse($tree->{left}, $func);
    &$func($tree);
    traverse($tree->{right}, $func);

    return ;
} ## --- end sub traverse

#===  FUNCTION  ================================================================
#         NAME: ($link, $node) = bal_tree_find($tree,$val,$cmp)
#      PURPOSE: Search the tree $tree for $val
#   PARAMETERS: $tree, $val, $cmp
#      RETURNS: $link(reference to the link) $node
#  DESCRIPTION: the optional $cmp argument specifies an alternative comparison routine to be used instead of the default comparison
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================


sub bal_tree_find {
    my	($tree, $val, $cmp)	= @_;


    while ( $tree ) {
        my  $relation = ( defined $cmp 
            ? $cmp->($val , $tree->{val})
            : $val <=> $tree->{val} 
        );
        return $tree  if $relation == 0;
        $tree = $relation > 0 ? \$tree->{left} : \$tree->{right};
    }
    return undef;
} ## --- end sub bal_tree_find

#===  FUNCTION  ================================================================
#         NAME: bal_tree_add
#      PURPOSE: if there is not already a node in the tree, create one. 
#   PARAMETERS: $tree, $val, $cmp
#      RETURNS: $tree points to the subtree that has resulted from the add operation
#      RETURNS: $node points to the node that contains $val
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub bal_tree_add {
    my	( $tree, $val, $cmp )	= @_;
    my  $result;

    unless ( $tree ) {
        $result = {
            left  => undef,
            right => undef,
            val   => $val,
            height   => 1,
        };
        return ($result, $result);
    }

    my  $relation = ( defined $cmp 
            ? $cmp->($val , $tree->{val})
            : $val <=> $tree->{val} 
        );
    return ($tree, $tree)  if $relation == 0;


    if ( $relation < 0 ) {
        ($tree->{left} , $result) = bal_tree_add($tree->{left},$val,$cmp);
    }
    else {
        ($tree->{right} , $result) = bal_tree_add($tree->{right},$val,$cmp);
    }


    return (balance_tree($tree),$result);
} ## --- end sub bal_tree_add


#===  FUNCTION  ================================================================
#         NAME: bal_tree_del
#      PURPOSE: Search tree looking for a node that has the value and delete it if exist
#   PARAMETERS: $tree, $val, $cmp
#      RETURNS: $tree, $node
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub bal_tree_del {
    my $tree = shift or return;
    my ($val, $cmp) = @_;
    my $node;
    my  $relation = ( defined $cmp 
        ? $cmp->($val , $tree->{val})
        : $val <=> $tree->{val} );

    if ( $relation != 0 ) {
        if ( $relation < 0 ) {
            ($tree->{left} , $node) = bal_tree_del($tree->{left},$val,$cmp);
        }
        else {
            ($tree->{right} , $node) = bal_tree_del($tree->{right},$val,$cmp);
        }

    }
    else {
        $node = $tree;
        $tree = bal_tree_join($tree->{left},$tree->{right});
        $node->{right} = undef;
        $node->{left} = undef;
        return ($tree, $node);
    }

    return (balance_tree($tree),$node);
} ## --- end sub bal_tree_del


#===  FUNCTION  ================================================================
#         NAME: bal_tree_join
#      PURPOSE: Join to trees together into a single tree
#   PARAMETERS: $left, $right
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub bal_tree_join {
    my	( $left , $right )	= @_;

    return $left unless defined $right;
    return $right unless defined $left;

    my $top;
    
    if ( $left->{height} > $right->{height} ) {
        $top = $left;
        $top->{right} = bal_tree_join($top->{right}, $right);

    }
    else {
        $top = $right;
        $top->{left} = bal_tree_join($top->{left}, $left);
    }

    return balance_tree($top);
} ## --- end sub bal_tree_join



#===  FUNCTION  ================================================================
#         NAME: balance_tree
#      PURPOSE: balancing tree
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: the diff at most by 2
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub balance_tree {
    my	 $tree 	= shift or return undef;
    my  $lh = defined $tree->{left} && $tree->{left}{height};
    my  $rh = defined $tree->{right} && $tree->{right}{height};


    if ( $lh > $rh + 1 ) {
        return swing_right($tree);
    } 
    if ( $rh > $lh + 1 ) {
        return swing_left($tree);
    }
    # just fix the tree height 
    $tree->{height} = $lh > $rh ? ($lh + 1) : ($rh + 1);

    return $tree;
} ## --- end sub balance_tree


#===  FUNCTION  ================================================================
#         NAME: swing_right swing_left
#      PURPOSE: the left  child is made the top of the tree and the original is move under it 
#      PURPOSE: the right child is made the top of the tree and the original is move under it 
#   PARAMETERS: $tree
#      RETURNS: 
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub swing_right {
    my	( $tree )	= @_;
    my $l = $tree->{left};

    my $ll = $l->{left};
    my $lr = $l->{right};

    my $llh = defined $ll && $ll->{height};
    my $lrh = defined $lr && $lr->{height};

    if($lrh>$llh){
        $tree->{right} = move_left($l);
    }

    return move_right($tree);
} ## --- end sub swing_right

sub swing_left {
    my	( $tree )	= @_;
    my $r = $tree->{right};

    my $rl = $r->{left};
    my $rr = $r->{right};

    my $rlh = defined $rl && $rl->{height};
    my $rrh = defined $rr && $rr->{height};

    if($rlh>$rrh){
        $tree->{left} = move_right($r);
    }

    return move_left($tree);
} ## --- end sub swing_left


#===  FUNCTION  ================================================================
#         NAME: set_height
#      PURPOSE: get tree height
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: height = max(left.height, right.height) + 1
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub set_height {
    my	 $tree 	= shift or return undef;
    my  $lh = defined $tree->{left} && $tree->{left}{height};
    my  $rh = defined $tree->{right} && $tree->{right}{height};

    $tree->{height} = $lh > $rh ? ($lh + 1) : ($rh + 1);
} ## --- end sub set_height


#===  FUNCTION  ================================================================
#         NAME: move_left
#      PURPOSE: 
#                  t              r
#                 / \            / \
#                l   r    ->    t  rr
#                   / \        / \
#                  rl  rr     l   rl
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub move_left {
    my	( $tree )	= @_;
    my  $r = $tree->{right};


    $tree->{right} = $r->{left};
    $r->{left} = $tree;

    set_height($tree);
    set_height($r);

    return $r;
} ## --- end sub move_left

#===  FUNCTION  ================================================================
#         NAME: move_right
#      PURPOSE: 
#                  t              l
#                 / \            / \
#                l   r    ->    ll  t
#               / \                / \
#             ll  lr              rl   r
#   PARAMETERS: ????
#      RETURNS: ????
#  DESCRIPTION: ????
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================

sub move_right {
    my	( $tree )	= @_;
    my  $l = $tree->{left};


    $tree->{left} = $l->{right};
    $l->{right} = $tree;

    set_height($tree);
    set_height($l);

    return $l;
} ## --- end sub move_left


sub show_tree {
    my	( $tree )	= @_;
    my @list;
    push @list, $tree;

    my $length = @list;
    while ( $length != 0 ) {
        for(my $i=0;$i<$length;$i++){
            my $node = shift(@list);
            my $val  = $node->{val};
            my $rval = defined $node->{right} ? $node->{right}{val} : "undef";
            my $lval = defined $node->{left} ?  $node->{left}{val}  : "undef";
            say "$val => $rval  :  $lval";
            push @list , $node->{left} if defined $node->{left};
            push @list , $node->{right} if defined $node->{right};
        }
        $length = @list;
    }
    say "";
} ## --- end sub show_tree


my $tree = undef;
my $node;

for (1..19) {
    my $val = $_ * $_;
    ($tree, $node) = bal_tree_add($tree , $val);
    say "add element of : $val";
    show_tree($tree);
}

($tree, $node) = bal_tree_del($tree , 7*7);

