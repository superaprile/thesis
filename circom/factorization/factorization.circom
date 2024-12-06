pragma circom 2.2.1;

template Factorization() {
    signal input a;
    signal input b;
    signal output res;
    res <== a*b;
 }

 component main = Factorization();