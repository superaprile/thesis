// SPDX-License-Identifier: Unlicense
// This file is MIT Licensed.
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
pragma solidity ^0.8.0;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() pure internal returns (G1Point memory) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() pure internal returns (G2Point memory) {
        return G2Point(
            [10857046999023057135944570762232829481370756359578518086990519993285655852781,
             11559732032986387107991004021392285783925812861821192530917403151452391805634],
            [8495653923123431417604973247489272438418190587263600148770280649306958101930,
             4082367875863433681332203403145435568316851327593401208105741076214120093531]
        );
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point memory p) pure internal returns (G1Point memory) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return r the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2) internal view returns (G1Point memory r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
    }


    /// @return r the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point memory p, uint s) internal view returns (G1Point memory r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal view returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[1];
            input[i * 6 + 3] = p2[i].X[0];
            input[i * 6 + 4] = p2[i].Y[1];
            input[i * 6 + 5] = p2[i].Y[0];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2,
            G1Point memory d1, G2Point memory d2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}

contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G1Point alpha;
        Pairing.G2Point beta;
        Pairing.G2Point gamma;
        Pairing.G2Point delta;
        Pairing.G1Point[] gamma_abc;
    }
    struct Proof {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G1Point c;
    }
    function verifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.alpha = Pairing.G1Point(uint256(0x22893cdfede5a638aaccc3f8224608201bac2a1c3f923536eb9f0f97d83bd03e), uint256(0x1ef5162c7d296d0231dd6f0f248bc7fded738adf7a6099fdf0de60d423304ab8));
        vk.beta = Pairing.G2Point([uint256(0x160b6cc411ea17ad5db0c49848408c190d7f2eb9ca8393e609c42fd46c1097cf), uint256(0x116be3d7c19f2c8e4cc4857e88a8b7207a0fd0d0a3e06eb7571c391710217a5e)], [uint256(0x226b55c490d9472cee37b89a0654ed93309a9007dc496aa7b1cde055c47d7b42), uint256(0x1f0958a48fa9ebefc0035d8f0dbc2e75d514192fb6e688d4f751105152b14a6f)]);
        vk.gamma = Pairing.G2Point([uint256(0x1dbcf977a7cff5d17dfe1423f8add377c0d33f41dd4e51f7c615119a1a5da7c6), uint256(0x2645148953c338323563e41fd5f0ed48e645502e08ece8295a91287594f07cf5)], [uint256(0x18ac85178fc4212ee1ad09df2feeb04b9a49c9cdc47a0e939d4cee5725328292), uint256(0x220e756f8a846043677b36e5c8942cb1f62ff05aa6ef748009c3a23fff332bcb)]);
        vk.delta = Pairing.G2Point([uint256(0x02addfebfe9ae7d2c4ea53d248039ad1c432dd0f14b4771575284e50e1c7bfda), uint256(0x22d079b6dd322f4f3dfe1f19aa4ddab4014646527269885688fe1f56ba515603)], [uint256(0x2bf22a22284fa5f6745d55a03ae92eb326a2988d04e5e79818d1b1cfc4736a3f), uint256(0x040b23cd5761f240451b3f12aa4c5c05c5cf1a256d1e209b83b6391ebe5612a2)]);
        vk.gamma_abc = new Pairing.G1Point[](101);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x1b5869e3478065fe856cf0f92ea9f3a9adad8be662977dd36114afacea4bf2f2), uint256(0x291946da31073b9a49022b250a6b7446377c1ba79408de2274a1ad7a6d8c7269));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x1c063be5499fef1816164e67c15c950e30a2d663a2153fb041c9bd13901c1986), uint256(0x2f9e07ad891f95f6eb232878831a30fd3921af72496c8447fbe2d5cb36caf3ce));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x094550392bd5c7157a39c12fdce05951c98bfe7741be99216bc4f10a91ef1750), uint256(0x12e058cf5ba08cba3951bb1c30dda35c28b33bc73b616f6ebd51ddc5104d0ab5));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x1deb447a5991e8d39b6172c4c015863e6b83ac4fffac7190f6fe2f658359b8ca), uint256(0x21ab6ad9a67e5a023fc015fc8f949870a24e761fe0d04c982522f136aea1762c));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x1f744f9c2dbf1ccf0ff742bd3ab0f7e3fb74b38e05380ffad40d6654e879bac7), uint256(0x2a637a434456407ba7073ef5a3b517a2d74c7d64d9ed59e1f240ab5570ac45d1));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x2bb701ab196ead7dec0e1e20ffc75f29e6e445c2d25accd2537353063915f754), uint256(0x2dfb29d805582cf77630806ff738a8e48b3b1bc7f99d2e4888a8eb5faec11137));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x013848dcc488f38b1d8d806d07dc36708d82d22a2d627978650701264ba27159), uint256(0x1a82ebba8675ab2499c68513e36f804c99148e3be2b332e84432fe193a925e5c));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x2cf60e5403419c57cdda9fa3a2e7317108955e5111cd6b5348b67200b02b919e), uint256(0x27641055eef7898514c2f00a690d6e9507f253a9bc98e5528968bcd13d6641f1));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x1da5550f7901cf5c11c8dc391ca4c296cd038c3efe1086ef2e60cda095f67cea), uint256(0x122e467c34998086a182ec42b2541e44e1bf31a6ec4399d60e4f83dd7e1fae26));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x0a4c565fdd0c01b6e3dabab148df42e3e7df07d0c414356e5c5b81d875c6372d), uint256(0x1da58dc9d2d240cef21ed3b11a0181a02f3977c2562519bb9655fca6bac3b2da));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x1e53305a567e58cb917e4cae9fd3c044df2878ac860070557d6a3c130c6f0c1c), uint256(0x015a43234f06dba6ec4fbe271324e88a71e63f5b7a69171fa8048f878c6c517b));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x248b407987cc736324d8a72fb001749a5416d109b5ef078fd7c40fb0559aa5b8), uint256(0x2fb6a3f4c383a04d48f06535803f7b5aee5bf1e37195203ee958c250167996e5));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x1171f1b832e4e54481926784b31e2c724dca5059cb72970e25095ba2ee8bd575), uint256(0x1756372d779d86f0e632803be3c0484998db3826d52d5fbb035aa5c9a9482ab7));
        vk.gamma_abc[13] = Pairing.G1Point(uint256(0x0cb501c47911337a684627a3cc328d640428f632f76fcb45444cb86df654e1e3), uint256(0x1e455991fb1996f8ed48c6561beaf7c395494d572b92de18d508a1b4d635d3cf));
        vk.gamma_abc[14] = Pairing.G1Point(uint256(0x0dd87c981cddef594f23ec43d4c6f1690de733f89b1b98709ba0d9282e043c46), uint256(0x19a390f104bae246900ce5c903fe4c9be54841c7b58e003f54de95505c471344));
        vk.gamma_abc[15] = Pairing.G1Point(uint256(0x1228ca70a0d0f0fe2873e902b949fd81a30f82abed455451cc71017c6b578d4b), uint256(0x25d63cf69429543488c7dd9b573a606471894c75e51e311abce4e6f37361279f));
        vk.gamma_abc[16] = Pairing.G1Point(uint256(0x053351026ed9912e43c5d883cc44e002e015e8bcd99fecba96263ad195549c72), uint256(0x0132dc7ec573ac108e5ebd5dcb30b79f19b12c18cea59cbb978a47269330be5a));
        vk.gamma_abc[17] = Pairing.G1Point(uint256(0x110766f00dfab5ecfe9b1e2b7d042a335e88d0ead61d6a0d9cec794dacc3d6b7), uint256(0x1be4943abb4f8014130070b0bbc222c3cab408e6855d1cb703300413bd4ea83e));
        vk.gamma_abc[18] = Pairing.G1Point(uint256(0x13aaf4cb35c089ae3fa11915bda311d7db2adba0584937b853ae03e863dde210), uint256(0x233963a225c468213711c4231a6ce8bbdef4053b25693cd80b1da4a50b389c38));
        vk.gamma_abc[19] = Pairing.G1Point(uint256(0x22caeb07d70fb5a21886e38d0b0c7bc9a5ce66d21d4af4bf36d189a3033de99a), uint256(0x1311256f37b92978e3efd748e4b1119b965d80e749a158d2c64e78215a146cbd));
        vk.gamma_abc[20] = Pairing.G1Point(uint256(0x27ce8824e58d5c9b76fa3bae853e2d8001234de7d6060e68ce85b7e376159151), uint256(0x15f683fd0c351ef525a70651bf30b3ca7d27f2ad85eb4419c792edf6cc7380f5));
        vk.gamma_abc[21] = Pairing.G1Point(uint256(0x29b0d267e3e798800fd70659d727a89305054f0f75781522c41b9d4c3936bef0), uint256(0x12f2a149142c6f95ac6704a69ea67bc055668541f9866a9abaef8033ba546260));
        vk.gamma_abc[22] = Pairing.G1Point(uint256(0x2804f5b39f8b26b3f7687201c95778ecc6589e871e92c95a07eb662bdf6c64ad), uint256(0x10914a19163e8474e7eb207b448b42021213a41c5aedf7dcf206034eb42325f1));
        vk.gamma_abc[23] = Pairing.G1Point(uint256(0x1b4b170cbb3f5c24dc21f841b20a3913cad2e621abd4bb553ef7a7523183b153), uint256(0x1541ccdbdd4a6d184c70101b12922eed7e853dc0a801318a290824f28876dd7f));
        vk.gamma_abc[24] = Pairing.G1Point(uint256(0x2bf390ce50c728169465f6568200e74552b49162eb9e3c626101874e637a01d4), uint256(0x08b49b9039f3c9fdd91225c8ab90e1b2f5dc4cf856191608c12534c0324c1736));
        vk.gamma_abc[25] = Pairing.G1Point(uint256(0x2ef42f447ce962abb06117c450834e3ef4e480be868d8247fce5ecdf02c6b8bb), uint256(0x0ca80b62cae57b01bfd24cb44670ead3455516601fd15b388ff988234cb92d54));
        vk.gamma_abc[26] = Pairing.G1Point(uint256(0x298911deb34dfdf19c4df4d297076c7e833fd11e448fb96adfb89742ac4a4906), uint256(0x2d175262cab8223bc33b1e5ed52915fcb97e5b510df57aa1dcc1d7a7e618eac9));
        vk.gamma_abc[27] = Pairing.G1Point(uint256(0x0e3464feec058ea83269e2988fac0768cc3e8d0baf566e42bd82e362422f4314), uint256(0x2ffa240e466af334dca5e29ac55c1c997be16536d46b62bcfc5e830e946698ec));
        vk.gamma_abc[28] = Pairing.G1Point(uint256(0x07d401a8ffdfb851d02f75470080e514f1f4dab3518d07574f0c9a960e172687), uint256(0x1eedaa3671f67e78bbcae2e7252695d5e2680450da266db78e5c9766c2ef91f0));
        vk.gamma_abc[29] = Pairing.G1Point(uint256(0x0db3a042ea94f8e45d659a2756498543d03d35866586197c6af9f45477aadef5), uint256(0x069bdd9431491abcc4d47bbeda11b6c63c8214ec71ffc23517b8eb3a53b7f799));
        vk.gamma_abc[30] = Pairing.G1Point(uint256(0x131687992ec02d8cf0fab7b35f9b6cf1b84e2bf3da77f2c324010b889da7eb56), uint256(0x1826ed1bc3b834f2ed70e14f5eb0a3396eebf9306feb0fed9b26b550b5a1d3ca));
        vk.gamma_abc[31] = Pairing.G1Point(uint256(0x13aa23d0eee83d75e06d5d7d98040c75bb9dec3feadbee045673c749a7747f38), uint256(0x0e75de8cd6e9e910c69bdb13a2eb286ab4797df69e7d8dba2ed5e524fd8a2997));
        vk.gamma_abc[32] = Pairing.G1Point(uint256(0x1670998181b3a1f8062a5972545e1575fbb0bca8c69c942e96bb331ce67b6535), uint256(0x2b2247e23b3b42210db89e0c77a9e9049173fb39859cb7c93b85782e2c70211b));
        vk.gamma_abc[33] = Pairing.G1Point(uint256(0x17b0c6e9aa689e9a141881d4250bfdcefdd3a43eb886e8b471bbf8672c3f61c7), uint256(0x1785a02369cbf5dc9337345b19b30aa7d330af1774c097a09374d4a964de38bd));
        vk.gamma_abc[34] = Pairing.G1Point(uint256(0x200e70cfffcc49135ddde73d1d72f995393a4238dbcda046d6a9672739a5c105), uint256(0x17f3f94f6398ed36210bc68c7a0e0d7e9450a2048a623555d87ff95f5b75832b));
        vk.gamma_abc[35] = Pairing.G1Point(uint256(0x11e02f1f943fe32edff661dd3174849175b0e997771d4c0760cee6a00d61088d), uint256(0x1cf02626250192b2ee0c4b535cebc7509aeddeb2acae07b6b27d556f914d0add));
        vk.gamma_abc[36] = Pairing.G1Point(uint256(0x18d3aed61c745136a8acf748aa14269141dfe6cc33b9ca8e4cbd0c16fa98ace8), uint256(0x0c4f08b6d05c0ded30f8aa06dabc04a271466d00d9c901ff90528cc271f00926));
        vk.gamma_abc[37] = Pairing.G1Point(uint256(0x01ff8869b78afb2169443bb51c11dea2a10c9d18a5bc82f0b390b9472a1f255e), uint256(0x1b9f30222aaca2335d36d861a87d07ad9c3fb46a4dd6df7ff3757a20e37b97ff));
        vk.gamma_abc[38] = Pairing.G1Point(uint256(0x0251a170fe0d86b6e22a9fc8ea06512f8f62ffe9c552f050bd93898bbef5d7e0), uint256(0x1e2d4d847611cfd58d52b5e51c5b4677ea386e983764c6cfda8512c156a4b479));
        vk.gamma_abc[39] = Pairing.G1Point(uint256(0x1f7741c6d3458e6db5505b5d1611e9d3ae4a2847f03ec68eb1ea528329e93f7c), uint256(0x10ff1883da444b9798f5fa7ca08a23a6320c44e63930187af0b30fcbde67e37e));
        vk.gamma_abc[40] = Pairing.G1Point(uint256(0x2c2f086e27bc5d01316638a1745e8e0511531a7f0fa6888d4f636cc1ef6f056c), uint256(0x29c7b0a2199d7888d3bc5c8522f96f1e47d86b871d37cb748d863c63b5d3174d));
        vk.gamma_abc[41] = Pairing.G1Point(uint256(0x006acf0ac358f8c2da4cc4084657fb85ba920716debf11399f018cf924a7a4b8), uint256(0x2f4cb4cb979da81aaef0019da15e5d79ef3629320a524e43f9580d5b334d5387));
        vk.gamma_abc[42] = Pairing.G1Point(uint256(0x1511a949061fcd98d247369b87e7672a86f43b0263205cb8c4fad5ffd4726d32), uint256(0x22baba07d3a0fb9dcd1394afe85d47958531a916a5bbd3eb8c8798334c94898a));
        vk.gamma_abc[43] = Pairing.G1Point(uint256(0x0d275a2aae27075e77c52ca2528209fc16601bc9eacad2bc9f688c4f90fda634), uint256(0x107e4125aa2660fa4a1da71777786966ef1adc9dcdcdfe119f4519553a2e83b7));
        vk.gamma_abc[44] = Pairing.G1Point(uint256(0x15ed849e93024e78a9442ae0d36d9f4adfb409dee37f0ad5a7d5fed5508a919b), uint256(0x29d0be5593002a3968e437fbb121a0d63bd53eb19c73ce0bb2fd4f94e03891dd));
        vk.gamma_abc[45] = Pairing.G1Point(uint256(0x23dfe2810f6772f85572eb14b3159ca99080dddee5b5198a78037867980e6dfa), uint256(0x1ed9605d6755990bcbb2e8c168d5e6fb6993a3fc4e7322b9e453b62553825441));
        vk.gamma_abc[46] = Pairing.G1Point(uint256(0x238c7c0d855c70a7086c0d836c1a7794891e63e92e656e96992ccd837451190c), uint256(0x21eb3e745cc3caf8a33601e7d71f2b88b451a0c90eae78ef2f22ecd31c173a11));
        vk.gamma_abc[47] = Pairing.G1Point(uint256(0x23063d028e7766fbf5d255a3b53e4db4838ccb7edaa897645736731b2998d5d1), uint256(0x2b82fb4b43d728620aa792159c11c63ab93615626038f5e4552a290266b0e144));
        vk.gamma_abc[48] = Pairing.G1Point(uint256(0x2786a391bc492225071bd17b49169c15f3664c3453ba93dddeb0f37d7f993e7b), uint256(0x08eab790fb627177fb0960260e31df657d0e8b63d2b2be9c40c7e811ba483128));
        vk.gamma_abc[49] = Pairing.G1Point(uint256(0x00fd246b7ad687a9397fe822d866eee3c13d28bd7c982a46a032abd32c3b9b76), uint256(0x2bc9199b6b90fddfcac69f8c2404da66281d512e641962e26f43b7d89aac090f));
        vk.gamma_abc[50] = Pairing.G1Point(uint256(0x065f7d8d9784f6712f1a03b4cdc22dec08c58d525fdd1712410ca19654909817), uint256(0x24e6def7ad1139d29566a1687d17ea8468754ae79c4eb549360f2876cc5e2672));
        vk.gamma_abc[51] = Pairing.G1Point(uint256(0x1302115e1a3cac372d0b834b4ce6775cd7e67939e861b89eb660e46a37ee9ddb), uint256(0x26314c6b1b1634f6dc2e39ced3763c7c91df8eb37b1625eb0d8d1801af6cdb88));
        vk.gamma_abc[52] = Pairing.G1Point(uint256(0x09afd8f5c1ed7edaef00e1841c48e919f7edfcb0f85b3853e95bb74455dbb184), uint256(0x141c91ebd45c05a6c243f8314561cc807a63995f8499880c1173590060ba4db7));
        vk.gamma_abc[53] = Pairing.G1Point(uint256(0x29d4e3e2ef3f05c3d76b9d9a7c0ccebc248713bcdb8363004501ed299fd86c53), uint256(0x21e774f34a5af3447414e2e0e4361492c498c7c989b085e2c69a17a8b440f37e));
        vk.gamma_abc[54] = Pairing.G1Point(uint256(0x225882a10df63c8827780814889d50ac2d3f51c1c5a9903c36d2b5e3ccb3f737), uint256(0x18d118e25479ae5c7eeaf325680d2b9fec368bbb03eeb35bd885dac23020e5e9));
        vk.gamma_abc[55] = Pairing.G1Point(uint256(0x2b5678c18e3a9561b25efa830fbb06b7b3dc89beb83252ffbf4112f6711af06f), uint256(0x155f1b25f7b9ff58406ab9b1ee521391af07109c70ec46beb5ef0750b651d068));
        vk.gamma_abc[56] = Pairing.G1Point(uint256(0x2a581866310c84e3c8f71e9e1f333e152b4e1a50b0ce7c196fe42b4d4ec6ffdd), uint256(0x110e6338eaff8f93d17643386cb1d8f9df44efd014cb5b59d32707270b09a9da));
        vk.gamma_abc[57] = Pairing.G1Point(uint256(0x26555eeb5f0bf85b12650bc9d28841d796f1cdcec9371216f6cc31943d40ec4e), uint256(0x2e7463029c333f4541fec26ff0eda8882aeb574262ac270aaed5d44252662b90));
        vk.gamma_abc[58] = Pairing.G1Point(uint256(0x025956827ddd8eff3d58470dd427582185ac6ba22948549d83f2835cb3569d32), uint256(0x266f182ee2524ec2eee012f8437db340b5c1c1b2a63659b6fd726e54a2cfcb94));
        vk.gamma_abc[59] = Pairing.G1Point(uint256(0x2016f6f2444195a0a82d6078b3f8f3053f8d6a67c81a15776f8a600efb2e3955), uint256(0x1fb05c6fcf200649176078098defde9b6e8be9c7e62f9095312979706812ee57));
        vk.gamma_abc[60] = Pairing.G1Point(uint256(0x190e8a34daca748812774725578cd5c07ea6148878a6a6e5f606a03c2ba27a47), uint256(0x2c3ad398ed18d1fc461e2d319b3815b3827b00505d7fa74d705abcac6be85c37));
        vk.gamma_abc[61] = Pairing.G1Point(uint256(0x05268b59d2cf3f9c80b52c31bb77c5cdd8038183c65c879cb26a0f3d29935418), uint256(0x3030f39283a6439bc2e22992f8fb987fb251972f64f36050e19247a444e0d2a1));
        vk.gamma_abc[62] = Pairing.G1Point(uint256(0x2c1082290e917ccc9fa0d41d557f4b9fdd00c8ef5dca3d3e0379e57dcb6ebaed), uint256(0x301313c0d5c9df160d5b4c840149ebce88a893e0f1b5b3fba53860fae0255856));
        vk.gamma_abc[63] = Pairing.G1Point(uint256(0x293dab28d643e8c43a1d8569e3aa56bf022506252ff0b62ff5357ca059ea3701), uint256(0x1de05e9f274d92d13d5a59aafef8add3ed2dce2dd26b5b798e1841e2510c341b));
        vk.gamma_abc[64] = Pairing.G1Point(uint256(0x2b6c6687965945278f44c6be1f3c36ac6ff24d68ac750d1f6b555b13380702b0), uint256(0x1570c17c4f601036701c66e8a57ef272fa71352b52edbc13978ddc543dac3069));
        vk.gamma_abc[65] = Pairing.G1Point(uint256(0x28c766733f6b6d6e322878460568d755cb8c64b059931db63b5f6e59f4c60f08), uint256(0x0ce9e12e97291fc87c7609c6e041b550c015c30a58a500daed1593452f44da24));
        vk.gamma_abc[66] = Pairing.G1Point(uint256(0x0f1ac1848e5aa69026875f9233ad57488946c7c092a0873ad86ca11c9d0f5872), uint256(0x2e83c116c98e617c651830f8565cd09b9f69d9df6c1ee26992a709a27dd370f3));
        vk.gamma_abc[67] = Pairing.G1Point(uint256(0x060157ee09cfc1afb2fc3306dcf65153709ee2d72542f657ab9bc6401fe3dd10), uint256(0x2daedd0cc8ea99e7088c1da96ef70634215af9cfd0dcb1c0ea989e575df30c06));
        vk.gamma_abc[68] = Pairing.G1Point(uint256(0x215043ac24b4b4a277fa0543eb6a48f41415ac5e129b01c38cd404d9bebfa373), uint256(0x25f12c21b79594f0385c347b08b65e8623f52074e7f6405cefa7b2a5bc802180));
        vk.gamma_abc[69] = Pairing.G1Point(uint256(0x25cff3ca252948dc39ab8d1637ef98e813913cc39c5d964d6925418d44732f4b), uint256(0x02a9a83a78fd9985cfdb6c014615ccfd17c56d6315ab0608d874796fb598ebfc));
        vk.gamma_abc[70] = Pairing.G1Point(uint256(0x0bd0e263417b300fba6a256b1762e0ecd0acaa70835bd47583e98dc55d6fe859), uint256(0x1b31db930d33e36c029c15eef5bfe55e0ade58438c9b0798d3457554500563f5));
        vk.gamma_abc[71] = Pairing.G1Point(uint256(0x1560cb542423aa14374a82aecca5fac8181b1d31da7f0718dc876fe642c7fc41), uint256(0x02579b6904ba3ed892d9b07bd42784ef24a16a54d91d5e684d237128290dcea2));
        vk.gamma_abc[72] = Pairing.G1Point(uint256(0x2c032811d4bfe40e1b0ce04f9516fe3672c5e52651dc50b58bdab754e42529e2), uint256(0x0f2ecc7daa67ea1bce888d76485f476eed6da83471d040c488e5e3339573f7fd));
        vk.gamma_abc[73] = Pairing.G1Point(uint256(0x1417ac6b806a5fa06e7af60e8b3b2a84d8b360f49dd0af61c8a745d46b1b5c05), uint256(0x248e8f0dcf0f7a10a28912f494d1b03a904ee976d3c6d97c4c414563d18d49e5));
        vk.gamma_abc[74] = Pairing.G1Point(uint256(0x08d667927d31f83cb99660b2de4e932fbf4b2ba3102fc6db4bf6440a2d263ec2), uint256(0x30137a29246ed8e907ee2c4e7283c92218137465b49226fd863a52f03938c96a));
        vk.gamma_abc[75] = Pairing.G1Point(uint256(0x08c3d95bd1e7fb69760ec326397ea5a2ce084f5fb82c01ed657cc6483a404109), uint256(0x117f8087ab7d1d0db48bb4e9ce6466e6458356651e3c6782241343f6ec61d17a));
        vk.gamma_abc[76] = Pairing.G1Point(uint256(0x1251adfbcd29791342ee16486da526835bab1cc77fb874fcdbd4829550344b49), uint256(0x15210ad9f0d15ace5f0921ab19b5b95658a3bc33f06af13fc7966ff96cbdbb80));
        vk.gamma_abc[77] = Pairing.G1Point(uint256(0x21f24d82359d073e3325440587daf02f3e75960d4236be48889c2b9356f485fe), uint256(0x1a2e0193bc69ac5ee52aa6a2ccd91529ec3bee0653039c6d19a51a81f68045c0));
        vk.gamma_abc[78] = Pairing.G1Point(uint256(0x01cb105b18dba58d153e7227374c0fe5b419b6413456090661b517bf5d0cd6b0), uint256(0x00faeeecf8bd1764e031448ff50459243bbc812fdccd2ed6f47888195ab03c8f));
        vk.gamma_abc[79] = Pairing.G1Point(uint256(0x0026dca94709e452e4e36248d5878270701b71daf3201201d207c72abc869c14), uint256(0x1638a6a02b1f4fbc99f266c923974ae5857fa74e1f5cdabb23f7e793bf61a42e));
        vk.gamma_abc[80] = Pairing.G1Point(uint256(0x0152becacecb06c815667c024a3d0ff53e25b954dec8f4cb8d6a88e7d8e9fed8), uint256(0x274d5c037a1049edef27ff8cb47b732576ff692da6eb1f54d188162a2767ffcb));
        vk.gamma_abc[81] = Pairing.G1Point(uint256(0x03a3b5682f3b4b4ab9dae505f8a135b5c31264ab15821120041de6afa0bf3f05), uint256(0x1a0817ce9cae29db953b71d26bbbdbff99ba37a4b954046e808fbc757325137d));
        vk.gamma_abc[82] = Pairing.G1Point(uint256(0x06c87ec1a597441c3ad0f559677798658715b85d61825a93458a297cb71a1e3f), uint256(0x1b855e2a12c8603bf3c34d3f9b034c3a4a14b7858a40e3216b804aa8c07e0313));
        vk.gamma_abc[83] = Pairing.G1Point(uint256(0x169b7767c2a6aaccf6bd38274b0859d02f454f6fa110f4cf5f09b74119d3a8a3), uint256(0x1b376619bbba94ba93b9fc7e6398624a73353fd2310cf2e31f237bf3fd15470b));
        vk.gamma_abc[84] = Pairing.G1Point(uint256(0x2079260b4650038a9baa548c2093b445857dce41d1da73bb75282130d745b2cc), uint256(0x2e09390909f8fdfbb80ed32f2da9310d7a9738561c0d40581000087eb4f5c0d7));
        vk.gamma_abc[85] = Pairing.G1Point(uint256(0x23b3839096176e5ac9a7dd79022dbc7899030c896951446298558af2991fd323), uint256(0x0b2e7012660cfdab16ee034bdda6af185cc834507eeff33a2d9a4fbaabdbc137));
        vk.gamma_abc[86] = Pairing.G1Point(uint256(0x139f87a65a721ec28e45916a4216b9b797b77aa2c5a23407bb899b4b8d77e6ac), uint256(0x183266e6173231e158b9d82d5d8c6b0362697e1249432dcb21087ae9ae85d2ad));
        vk.gamma_abc[87] = Pairing.G1Point(uint256(0x25c620e7219a73c5696c7a577554851e30be451ccf7a927a79a94466df4414ea), uint256(0x0606cba4d586a1aabaedf5a4842429602ee5f1a7fb9bf0f2b524566563661a0f));
        vk.gamma_abc[88] = Pairing.G1Point(uint256(0x1eba97d0bc448617bf8daa05bbec937aee27fb45c612ca23c522dd8059d1f5b8), uint256(0x1f29011bf1e2a9e0c8fb9f2121158de01cfee5fa0609c6b0436aa877108f75c0));
        vk.gamma_abc[89] = Pairing.G1Point(uint256(0x2eea8f9c676f41bcf725c591a3c9992bfb1a6afd9045f86259031c23677f2032), uint256(0x255e58d9fd1a44a0d57a77d0a5d5dbd536c8b2693a277ee398f57fb1577892f0));
        vk.gamma_abc[90] = Pairing.G1Point(uint256(0x248ef3933c08e64a63cad496bbfa834f2153f1f0307a6a737bd1d9e1e8d3e603), uint256(0x2b852e4db516a716566598f15cc1518832236bc49e3cf8fc6dbdb461a84771d9));
        vk.gamma_abc[91] = Pairing.G1Point(uint256(0x13eca23fa887c9671c4e68d1290ad752862286838a4d8f61a0820ee73ecb2731), uint256(0x2da6024a9473b55a303182151ebedce8c349f878acbed2e8840ec39b7c434cc4));
        vk.gamma_abc[92] = Pairing.G1Point(uint256(0x018375463c621c83925e29a7d473c413379d3f6df3e072bedd33fd879cf21b57), uint256(0x21b0b5762b2d39ea018b26ef60067451492c3b8f77f6d64d29e53447605ce2e7));
        vk.gamma_abc[93] = Pairing.G1Point(uint256(0x1493e842e2b8152688a22c7b339b34e9e388ea025785042337e1924b78163030), uint256(0x0f331d4e8b67fe4fa16d94a676af6d0e3ba3980d240a392c75d41dc7baf4f5a9));
        vk.gamma_abc[94] = Pairing.G1Point(uint256(0x07b6aa8e27d7c7298d9975ec3fac555115378324a7659feb0c54b71a3b7841ca), uint256(0x044e44a4d23c8f179da73c17c44aa2f52a23de7598bef098d6f436061d069e7d));
        vk.gamma_abc[95] = Pairing.G1Point(uint256(0x15b0734fcd8d6f4a7cd8c1751d1f9d7b41111b864ccba4959b219ffd41e7e064), uint256(0x11398ebda8ab7159aa9dcf6b8c02c8686543b490d4e9867d48e5da9d5c903f01));
        vk.gamma_abc[96] = Pairing.G1Point(uint256(0x08ac001f8af5ecb87fbcfa234e7bbcdd556b70b24f607fcd8221828cbb2c4e72), uint256(0x0a0eaf8a36664cf201a431dc6a6ab56f77dff17ab60617c2c847690d3a0cdf55));
        vk.gamma_abc[97] = Pairing.G1Point(uint256(0x1746f068a4e78114294cbce8e92ab35e5c76cdbc43769cc5a12e9aed4c313678), uint256(0x2929b202be49127d041925dcd878a8f610b92becb4269f863f12565b42f3c3d3));
        vk.gamma_abc[98] = Pairing.G1Point(uint256(0x2981f82c11b45f3c1f538e796b703c3c28458a59de8b33b72b44c89fa030e13c), uint256(0x0d652feeb21ca649f9190dfa21e1bbc684023ffc6dcead435c1f5f5d9a0e4421));
        vk.gamma_abc[99] = Pairing.G1Point(uint256(0x077639012ac84fbd6ca8c8982b2cd3e640a04486877ddf2b22059c4ac6bb35b6), uint256(0x16961fc3412cdd24f341cceb4c6b81340e530bf1735d9d640604b9b7cdfd253a));
        vk.gamma_abc[100] = Pairing.G1Point(uint256(0x27f897130dd23d15757a15e44c295157896eb7ab2ee0c7ad688c470b2d45a83c), uint256(0x079280791c172b8e8e5cb6b478b7248bd0f69bd19c7ee67ced24c46049a19b54));
    }
    function verify(uint[] memory input, Proof memory proof) internal view returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.gamma_abc.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field);
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.gamma_abc[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.gamma_abc[0]);
        if(!Pairing.pairingProd4(
             proof.a, proof.b,
             Pairing.negate(vk_x), vk.gamma,
             Pairing.negate(proof.c), vk.delta,
             Pairing.negate(vk.alpha), vk.beta)) return 1;
        return 0;
    }
    function verifyTx(
            Proof memory proof, uint[100] memory input
        ) public view returns (bool r) {
        uint[] memory inputValues = new uint[](100);
        
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }
}
