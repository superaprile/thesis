pragma circom 2.2.1;

include "node_modules/circomlib/circuits/comparators.circom";

template Age_verification() {
    signal input age;
    signal input limit;
    signal output old_enough;
    
    component gt = GreaterThan(8);
    gt.in[0] <== age;
    gt.in[1] <== limit;

    old_enough <== gt.out;
}

component main = Age_verification();