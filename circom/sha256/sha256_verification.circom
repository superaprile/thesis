pragma circom 2.2.1;

include "node_modules/circomlib/circuits/sha256/sha256.circom";

template Sha256_verification() {
    component sha = Sha256(4);
    signal input in[4];
    signal output out[256];

    sha.in <== in;
    out <== sha.out;
}

component main = Sha256_verification();