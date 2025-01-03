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
        vk.alpha = Pairing.G1Point(uint256(0x2c9ecc16a9e9234f52d7482a30eb10ff7f2669ecada386a4a7f7b2b9c4a64fc3), uint256(0x1679d90a53e6e35228c0d2ffac3e4f01c91881b73102a02531d35715b20acd45));
        vk.beta = Pairing.G2Point([uint256(0x2ada8d1003f0e9715b0f84c1d3f199c518b101c4f300f8dabc214910950ed747), uint256(0x0678a8c2cada6a00ef0902ed18641b809a0bece51247378865e5534fd12b40e6)], [uint256(0x2bfa71f54876a1a866ea42f3894608e19c6c4a00e649a0349a3a3fcea5b257ac), uint256(0x2795e6e5f9d592d12eccc40956240a003380050567baa7338d8e485d2689f38a)]);
        vk.gamma = Pairing.G2Point([uint256(0x20748ed4788d621a3bfe50e9bbbf8eb03896d1424fbd56a59628ff8e906f2872), uint256(0x07cb78e9ad3fb6689d39753930f3070c1ce2ca0a833e50975b56d3de81fe50af)], [uint256(0x29150f1a4945c73ee26aa6f6a1c7a0ffcd5ed9c0461fb40adde462aaab2816c7), uint256(0x2378556b675cb9527c39fa1d714a7d5893e3ef5d5653de88167e92d1e2e7dd84)]);
        vk.delta = Pairing.G2Point([uint256(0x28fe492da4d51fd93f0ef866526c6e86a9798009b434693fd03e5b79092d1014), uint256(0x1ea5f1f463dc0dfcb6bd1b607f5236c7b336a1dc16081e10385335d19f0cc55a)], [uint256(0x2ac890e03ccc229aa553a22633cdca5b15ab4c9385a6c216fecba47c45b7d31d), uint256(0x1840eb8a5c2bf87d436773330bd2f19693e30092bd1da8bbb906d34111e17f84)]);
        vk.gamma_abc = new Pairing.G1Point[](82);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x009134acc4831d8888c230f8004a9065406e92cb25141f4e9c67427c64d9d3f8), uint256(0x128c42f199c65300dbdbc03dad00d3f529a6320b7f9f6f19fda324f28e653d7f));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x24efc8761b13c8ef7294b00d7adc37a8c912060aeeaf6fd38228ebb3aa85c06a), uint256(0x1fc9bf8d7333051c60d2191016cfe4147066d8c1dddaad0fe64813b10f5ae684));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x11792c2f42edf5c022b915d5bc8df5ef23da64a934b44e19b0d9a558686a95fb), uint256(0x17e9c1ef7e5cff04a3333546db0dfe23ee8729c6535d9f69e690c2a1b6c22d7d));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x23ea372e1782a4c3188e3e627f29a5735ac7b8e838983ff183c3ea66886fd322), uint256(0x1239c18824a18d085166bb3ab45defd36b5d71ef19d762d8de619e8b0db8b019));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x2cf9f86b8dda5879b97c577bae7eaa12ed4e1d8ede1d5af5500fa1d87f83c66c), uint256(0x20b461542fd16cb1bf2cdbeadf12785ee9ce143413de9e11e3b3ab0545c89453));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x2d33a9c7a40c68f680d89debc598801058b3e9f64ad6645e609596a602d9fa80), uint256(0x0cce216e1cc088ff1ff06a51a1254eac4e4c2a9062f728889b47725e98863640));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x2a50132db44db769a3606eba1e8882444f6666c14303d63e4131e9e929ca5fa7), uint256(0x167cad5d6a204f032df6af06c6d0cbdeeb755d51e0ae115787f863975e73630c));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x28849702027019516473b6ff3d3cf0534e0435f234d59c7764df5d9392bb7567), uint256(0x0b911a33d5b2fd38a31b07668c8117c72f22c0a484eae40ea9f77ee8800284cd));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x2cfca1f17fbfbd30c5a01a30e2747602ddefd243f90146aeaf5f46ff34ae95ff), uint256(0x0a330c3e3c219d2efcafc24ad68bf535c9da2ba3e15d84449740b14c1071ad05));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x1435d0298e2785522fb0001391a55d38448b6144d3b31cbb5015b3b57f677270), uint256(0x0693db653eb83a6304026f730419debccac1bb3c77212c9e53d9bcf09735e367));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x04c7540d60f63a936f926d56279c97871289affc7c641c8987fb7b6779527f26), uint256(0x0078fb4c85120a075bcc4a8b300e355eaa2387ea917a6db6bb8ef8e5ad91ca31));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x221eceaf01a890e5ff204ab25297231dd9c93f4c424691d3d53cc12951c62e82), uint256(0x160ea82221c194bb1f045bff92d83ecc507837736eff469efbf9892040fb0462));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x29f5c794d8a84a8f033ae0e1b07a7cec4df7949f627dad1f106c6c15451eaeef), uint256(0x01bca29ed8bd38cb43c3358d977e4060a127f73fb955c053e5691dcbb4a9b22d));
        vk.gamma_abc[13] = Pairing.G1Point(uint256(0x1d437189e85259cc176a775920d8cef135d7c5546396d6e6ebc184c148c198ce), uint256(0x062c076be4eaf3c23832239854e65ed6ff4198ef735faf211c3bd269ad6cffa8));
        vk.gamma_abc[14] = Pairing.G1Point(uint256(0x0721e9e2f664ddcdbd216f9cb5d9f6d93c6ba9b1d0221dc1d5f073668cd25ce0), uint256(0x097b019b552744dc03bef77bff91a4ec960c140e5d07b78621ba01ab34b13f72));
        vk.gamma_abc[15] = Pairing.G1Point(uint256(0x23ea4ad5c2bba079c3299b4a06c27db98af28febe5531d37e63438b7087d4dfa), uint256(0x084d22bc858c6901104d5a35afc1d853ad0841e2b5996436211364678af4c922));
        vk.gamma_abc[16] = Pairing.G1Point(uint256(0x1beb5af8e3d6f7bae5ea408b39c386f88f2efeb48506ea2dfb6d2b0590098545), uint256(0x2121a1541e824d0e08c8aa4e3fc7d4b8de04258a4cd04e11b68ec7d2e6cda2df));
        vk.gamma_abc[17] = Pairing.G1Point(uint256(0x178b561f019a9d963a7ec4d2a29985d031fa36165bdb32c44abedcd102710dc9), uint256(0x2647d6f0b4ec4f681c7003a66c49dfe17692178912db414f9ab46125de2910ae));
        vk.gamma_abc[18] = Pairing.G1Point(uint256(0x0a76d4e4b9ae12b176ed2bc877931fb5846621d22416aae9e04058324d60b677), uint256(0x216a609b999026f68b8383edebb1747a89cc18d2db30a07d34f39d2a27def6ad));
        vk.gamma_abc[19] = Pairing.G1Point(uint256(0x296525807f1982b09042d14983d3cbedb8564601fd9ea5bb429138c9b6512010), uint256(0x1b31e951ded598f1c5575fc4732b69cb67230e0d731d8ecd5b5bd96e17620738));
        vk.gamma_abc[20] = Pairing.G1Point(uint256(0x10bab6933755f60b49d00ace9b13d46026e75411a817fb414e076f83e021e9ac), uint256(0x3060d501529f2af4eb45d2f5c422352e8589f72fa05c0f4828a0303889a5a127));
        vk.gamma_abc[21] = Pairing.G1Point(uint256(0x0723022f8c2e3323acdf43538b93b418ac884f95f21245caec52dbc6e6de2cb6), uint256(0x1fefb73b84d61d2a7a3c698af729036b316043beb3d38dece3c55f1739d50e71));
        vk.gamma_abc[22] = Pairing.G1Point(uint256(0x0c319c250f197713e1a42167a206c33b0bc03ed2b30e7a9f85deef4b0b685163), uint256(0x2126aa7c4b6753dcf030b6b2b95f4827f8b8e09cc0c3c536b51709180244531b));
        vk.gamma_abc[23] = Pairing.G1Point(uint256(0x2779565e99131dd6ddd34be9ed1fc0353175e16fb558dbcce6acc68fd6f29994), uint256(0x0ce465bbecdb8bda3e5c577ba7dc2068052be823a070a03fafc726d7cafc0ff9));
        vk.gamma_abc[24] = Pairing.G1Point(uint256(0x11df3ac88fef63e388dc4bc35f9e1fcbd94a98b0b8778d3b4744cedb287c6be1), uint256(0x1e852aeeab162f02581c16f648d3db1fdecd608236374fb289844f43e55adfca));
        vk.gamma_abc[25] = Pairing.G1Point(uint256(0x2da330b6fcff5746b2961258ac564676f5129d7e32f2efd55b78527185f517ab), uint256(0x1d7a960d4fd3a7605225ecda138442c63e3fc636f58de8e138d3061eb8f84aa7));
        vk.gamma_abc[26] = Pairing.G1Point(uint256(0x07669e5a995dbd70c7ec9e3e505a9af9606a334434445ed50418726aacb3b048), uint256(0x27ef1452175d678a8d6382f5dc56596f3a7153c6976260fbbbe8a0288356245e));
        vk.gamma_abc[27] = Pairing.G1Point(uint256(0x0bdf6e7c06c277cce9a41fe934ae608d08c5ca106eac8d4317131d5a99998e4c), uint256(0x283f02d4ddbae3b7e9acbcd59362f48ed95007507015f47c557468eeb10ec6f7));
        vk.gamma_abc[28] = Pairing.G1Point(uint256(0x2247c7ba6324c35dbeced70d8c00ce304122808383735f469f15d8add42ec1e5), uint256(0x22f5c12696a6f5c46b330fb20d6513ff4bbcbb0f9deb83617d25e19f5fd631cb));
        vk.gamma_abc[29] = Pairing.G1Point(uint256(0x15a0993512712d89e23eb7a1be769d90e984e7a0c3a1a01b977dd8dc0f27131b), uint256(0x055876f7529a2a94c0957e22df9311e983181a0857cfc54d96be57926c3382a0));
        vk.gamma_abc[30] = Pairing.G1Point(uint256(0x2725574065efcfda5d6f173ed3f6f0293283ba6222a180882a7bd2bec3c9b462), uint256(0x2838435fd5c0247bdfc4fe14708852bae45f06fe98227d97af57df24f1a9e803));
        vk.gamma_abc[31] = Pairing.G1Point(uint256(0x03cf75922d75437c212177020fc178566a49911b80646a0c9b3206ff9e616337), uint256(0x1e735a342b137b71edab1a8dce6a2432cb92f4b210c16579fa7bebe4393d7240));
        vk.gamma_abc[32] = Pairing.G1Point(uint256(0x16fada01f8b5bf3132f0a6748b849540f57a1c2b10aff62aac49c0ababe9119b), uint256(0x1dee61ca8df5848e5f5538cb3e64ca9b01c9538957abcecabcee570e5c4dd7e8));
        vk.gamma_abc[33] = Pairing.G1Point(uint256(0x1c6ae0361103eb4696ee63b12f54e4e684fb1b5282bafb4de7ab55020b23f7a4), uint256(0x00583094700a23562cf368f7a618e8d2908fda23bbe9fc86a38b499bf7614f4a));
        vk.gamma_abc[34] = Pairing.G1Point(uint256(0x1f4e6ab5cd7c057dd9966e07d9f12ccb77e336fba6a736cae822973a2b1b5d37), uint256(0x2ecadf93e975bd4bacfb4bfe7170f8b06c98c1c415cb6287998602dc3f37f357));
        vk.gamma_abc[35] = Pairing.G1Point(uint256(0x2d409528074c5b9bc060c94bd7a677a0d37acdbb383de440621140660d2f46a5), uint256(0x02fdcdace2c60fa380c3604a4681f5274750821c21841ba2cbbbabfa1ad0d8bd));
        vk.gamma_abc[36] = Pairing.G1Point(uint256(0x20930ac9bff89b9fe3c076d358ffc8a90fbf8c7adbd7cff6f3a780d31b8e6595), uint256(0x27b21a6c37d02f5ab5ceabceb461cb368cacfa254ee1d31fbaf34c993a193ed3));
        vk.gamma_abc[37] = Pairing.G1Point(uint256(0x142ee7abedccbbed9650419ee470c9791920f69423635df5ffe5bc63b115d518), uint256(0x2ea570b1458c365c020d4dfb9eb27cc670595de82279ad0e236dba824e41aa3b));
        vk.gamma_abc[38] = Pairing.G1Point(uint256(0x09cacfabe07ef360bf6a40531a8a91b810457864bd8c765569c7af8b50982541), uint256(0x11dc684eed9d26f6e14a8820f16c1f9c0db5054492dd0f688a08a6678f24ce62));
        vk.gamma_abc[39] = Pairing.G1Point(uint256(0x1c7d5f543d0aa8751354588e32afc18acb7be5e60f4471ffb61170ca71bdd9ea), uint256(0x228b3a0d551398ad48badae6d96d4eb3efb80a7efee03c933a2de545bc1fcf6e));
        vk.gamma_abc[40] = Pairing.G1Point(uint256(0x2c092c37533c13867f5055f37bf1a00f3e90de4283d2537c9bdd9764fc201579), uint256(0x028a3ffe40cb3779bc1e47c5de0164f28ac9c8c5c3bc4ebac26b19fb2a402059));
        vk.gamma_abc[41] = Pairing.G1Point(uint256(0x1816c787dc2bef001ee5d375eded56c12382200f96016a92f5c402487f6bfee5), uint256(0x1208ac7e079ab0542586d5c0793f705279462ae0b426cf366aaf90b466e23cad));
        vk.gamma_abc[42] = Pairing.G1Point(uint256(0x20036100de49fa21b2bfedb5b027d3bd3c73df3f2ce40d2a60155f4806565bfd), uint256(0x24882b1f9359f8f3961c2c0082143b0751382c1dbc835a7592c4c250648bd10b));
        vk.gamma_abc[43] = Pairing.G1Point(uint256(0x17999c4349ffb2d3b0dbebced8baefa9e33c7075c21978d5d8f31e4db04398d4), uint256(0x1be0fa68ba73438d4ab7822df435f4c6004a7c8fe6eb37a623336d6ed46896ec));
        vk.gamma_abc[44] = Pairing.G1Point(uint256(0x0c1590d8d5fd813233b5fd1183f23a72fb9a9742cec58cb9966aadd5c1f014b0), uint256(0x2af04d1ce2fd8e8ac7fe209171f9586b4fb7cbbbc0d75bb3371d60eaa1af8baf));
        vk.gamma_abc[45] = Pairing.G1Point(uint256(0x0296c7394b277f2656089d0d568e38a84df04277e89a9e2df9d4ee4848e903e8), uint256(0x1ab784a6f93739ef021cabc1ae4fb97509d4c041e0ce7710099fbe73edcb67e5));
        vk.gamma_abc[46] = Pairing.G1Point(uint256(0x2424d7bdc5cb3448b47824bb4647ecc5eb85e12ceb0b32f4a91e84951f77b7cd), uint256(0x22705cf29bf6d186fae29fd56398a9ca3df8806d4fd0f06a3eb25f3eef4dc860));
        vk.gamma_abc[47] = Pairing.G1Point(uint256(0x2e7739138f697e38916954d98ba18f6eaf481614d8312a292f4851185412af3f), uint256(0x0b69319f4d17e7276e4687bd19e7b42ff5406aa0dd576729e128180433ed2158));
        vk.gamma_abc[48] = Pairing.G1Point(uint256(0x2bdc301809607dfe4874e480ca70af91dfd716b0283284247cccedf7a825bd9d), uint256(0x0f753f685ee13395d26a3c37a78c838d3261bf7d7ab52a086fcbde23a22d123d));
        vk.gamma_abc[49] = Pairing.G1Point(uint256(0x093c4822f52a343e8b00b8caee1a9f37c6fe33d72854003dad367d1a7e4b38d2), uint256(0x2f496ebefbb8f290a4ebafaa64256cce082f4c390bdd7e2cfab1107161d7e676));
        vk.gamma_abc[50] = Pairing.G1Point(uint256(0x15e713150ba1dc7345dec6e101e7425b7e9827f850f866a0279ca56521756543), uint256(0x07bc25c4d7c0dfdd725a127b7265dd8fa43cb7611c1f9a17a3cd54f587c02179));
        vk.gamma_abc[51] = Pairing.G1Point(uint256(0x20eb56f95cda2e1c3097541161b7e16702ebf00992dba67931119425073dac44), uint256(0x25ac754baafb265d518136a78aa73b45b90e37a78e69fbabde492d90a853ac99));
        vk.gamma_abc[52] = Pairing.G1Point(uint256(0x230379bbadd70e19ff55fcb6322e0332f9ed04f776c868c16c560ca2f9c76ba6), uint256(0x2966be4a3d15e9d64f6155c57ebcd317a6755a37ff4a859ab1a44d2b4dace592));
        vk.gamma_abc[53] = Pairing.G1Point(uint256(0x2a07b46ef758b86afcc59e36523a43de581963a14a0c4d0b8651542e499446e9), uint256(0x2c2845389570b3479147959b70c480aaabea7eb020d0046098047a3abe327d3b));
        vk.gamma_abc[54] = Pairing.G1Point(uint256(0x269b1ca61af531945be776cf203280f181bd3be030d24fab4c6a48af6f87dc1a), uint256(0x0924fbc40b937c5ec0e6d0f8b1eb89d2a9b7d6fbfe5d39d3cf5cca26f15856c8));
        vk.gamma_abc[55] = Pairing.G1Point(uint256(0x0ddde6861027370f22693c28350c8361b28b7a554415780cb2d5133e5d1e43b5), uint256(0x09a0d4b6d5a30d617f540d59a7e186cd0521bcb81ab7c45a8f7c6277ad8bdd4e));
        vk.gamma_abc[56] = Pairing.G1Point(uint256(0x0cf8551b6e7811798e9fd0c9c10c17e9b027eba748b56768409b48908592d53e), uint256(0x2d8d4838fcea84f209bcb38e9cf976a9e0de46646c908079ea87e1a9652dc3f1));
        vk.gamma_abc[57] = Pairing.G1Point(uint256(0x23aedf90e31968f3128e27a7e64f73315f77395d1e70407f16dfb9af4e716363), uint256(0x091858c7bfb19e287424439003be91e9c0ab213cc53b375cbd907c986f89f7d9));
        vk.gamma_abc[58] = Pairing.G1Point(uint256(0x203937d082724eecfa4c3070886488b425d021a0abce655bf0703f5219b80c22), uint256(0x2584a05374a1a1c0c1af56250edf34160adc27f68b77e9e2cbffc59cb8c0fe83));
        vk.gamma_abc[59] = Pairing.G1Point(uint256(0x06ec5e7a969bb5746e86c7fb8671806a844445c4c0d6f26cc65fe2930190f385), uint256(0x1c6d43073f59529f7b04c363689c35cf23106ebfa18c6bf287ca9add230a0bcb));
        vk.gamma_abc[60] = Pairing.G1Point(uint256(0x0ec21d6c7b13fc79bd40687a1e0f99adbcac94a4fb4715e1b21cca30774c9bed), uint256(0x232903442f600be07cf75ee5d0fc12cebc87ec72b3532a93d63a4f25286ca64b));
        vk.gamma_abc[61] = Pairing.G1Point(uint256(0x18cf4c1d9213714c7a047d5c84377c424fe664971fdefb96164b9db606ce3e24), uint256(0x26e9b595fe922ea0b171080779f4e4b56a8ed66e054500eb6a731eda13af0edc));
        vk.gamma_abc[62] = Pairing.G1Point(uint256(0x0c031338c5cb8f7c618ca1bd3abbfd89dfbeb3bff4c8c190bbc5f8a5bb2af2ca), uint256(0x2407f177fe381e0d50b0c0dfccd58bf65a29c04bfc26337295f978d459ccf991));
        vk.gamma_abc[63] = Pairing.G1Point(uint256(0x17a90f1067743b3464e918d781084523c7390c207d0cdb9c63c56bd636d57ea7), uint256(0x1be235f2915154ab683e26aad1dc2dfc7a7499cf5bb52d95be4a526b0d5ba2ea));
        vk.gamma_abc[64] = Pairing.G1Point(uint256(0x13a13502c7a992991bf90c48e342860711cf9e1a12148b305ec14c03b8e9c0cc), uint256(0x26dcb0620bac82bf655ac3cfe2bcfd3acca792b7518d8780e39e2bf7602cc1b6));
        vk.gamma_abc[65] = Pairing.G1Point(uint256(0x036626dbc3ef6937f7f3967f23b74744164cd461414d0007508cabbb20f274e4), uint256(0x2e5d3603b194fbb7649c7f3cab85d892bb517a4fac06b45c659662650b4ad1fb));
        vk.gamma_abc[66] = Pairing.G1Point(uint256(0x0a044d6dc7c8ce56dc04b7063ad9483913546704f832130118add68c5fdb12f8), uint256(0x1e5f71560e8fd528b5f3ee18944a9cf9979e4dcf9b1e25d9cae79816107bb2e4));
        vk.gamma_abc[67] = Pairing.G1Point(uint256(0x0c73ab5e0633f3810cad83f596599d02e6e7996ba2378a6d3882cfd1586c43b2), uint256(0x02db358efa829105753898b259fca2e48506ae58c2f6558961ef9d8266f6189f));
        vk.gamma_abc[68] = Pairing.G1Point(uint256(0x1a9eb5bdf4a132ead2547dcb1a637b57859dd5ee31a942c6730dc38da7cfb156), uint256(0x0f66d2fd4c552582bd6dfb16098f8a8715bc4c18ba9855cea3d0f143206ac543));
        vk.gamma_abc[69] = Pairing.G1Point(uint256(0x0b310e03855ff023f7d87e2bd4d67cb105e6b318ddcd46fbed834293368e357e), uint256(0x11a6b788c44c1584691547cb8f57a40ee2a41351da3ec5e29141cc9855410fc4));
        vk.gamma_abc[70] = Pairing.G1Point(uint256(0x18666f402d8785b25a08eab3ceaf0ecd74542313d06e9bf173896cf6989369dd), uint256(0x0bab233e037f62dfe5499b81d9bea6b5c5e9a51163f5139e0450e90743351678));
        vk.gamma_abc[71] = Pairing.G1Point(uint256(0x2696eb6f33ea5ad104d8de1c5889c53e1468913ffd017407c6a3d6f71ce27113), uint256(0x16658c75613ba7c472535a9ed0b25c7f867bc679a249e909de46ab08702c886a));
        vk.gamma_abc[72] = Pairing.G1Point(uint256(0x263de4cb1c531f3258b0471b267528637bb84e26d029d37ec4d25cf293ee728b), uint256(0x207c548bd06e2365582e38923bc27be5d932a0a52c3d02bf91e57af510e8eb49));
        vk.gamma_abc[73] = Pairing.G1Point(uint256(0x2b7e7bf372b152bab9502b3f64258612309b7d16576fb62dde00464cb24fa806), uint256(0x280ab65eaab7397d9c3aef7400a672dd67e034bc723dec5856115fe35ca993dc));
        vk.gamma_abc[74] = Pairing.G1Point(uint256(0x0348195b4c44f9c3ec67357db40335d222ece39cc93fa02f9836ecb6c7c1556f), uint256(0x1501e918b0304cce12ad54197a0be42bb81f69d7ad45b958e96e8d07ce74b8ec));
        vk.gamma_abc[75] = Pairing.G1Point(uint256(0x02bd819f8de682e0f9eef88fe89349e8c1a82ce4f40e143c64fc71f2ecbf9dbe), uint256(0x2bdce5213297a532aa3fd35402da8f726483873639b3d938730efe8d63494c44));
        vk.gamma_abc[76] = Pairing.G1Point(uint256(0x01bfe4535d80d784dfa9e30411e26822f906ccea26241c55b349e213318b35c3), uint256(0x0ae5842cce8418a7990db26fe79caf089a1915f19153cc4e1bddd99d216bd690));
        vk.gamma_abc[77] = Pairing.G1Point(uint256(0x2192c0acefa6e721c6b7f0f12e30b982a4686b4fd2bf309822c65b5353f8cd35), uint256(0x05c6bd9c122203a557329b3112d7e4c181d6597c80cbbedd9c7e9f96c48d5146));
        vk.gamma_abc[78] = Pairing.G1Point(uint256(0x011cbe5890684d82bf1c579d25db7ec3de4cf3e20ef94d8089a7ee1eeca9fcf1), uint256(0x10f1008d4415b13cee3196f924285bde6eea6d2ce62caed4cdaa14ece8626e28));
        vk.gamma_abc[79] = Pairing.G1Point(uint256(0x01b532011d66990e8a8aac238b5a84101d86f34e74c75b5785049c463c717981), uint256(0x02b5510b5ed3739c804329fd98181708b9cda9794e266daad15ce74510681c1b));
        vk.gamma_abc[80] = Pairing.G1Point(uint256(0x0b13578378fd32c90e595a4d834a47dc8aec2fec4e67f1fe7b08f16137ab8bfb), uint256(0x2076c318e8bf1a9ec444be6d8229ce1512ca160982de57136722705b552ca245));
        vk.gamma_abc[81] = Pairing.G1Point(uint256(0x02059a53bf12f13e7fdb96a0d7b89a9e517bc605112ed5f91df17596c091b2a1), uint256(0x0539e02dc3bdc1f48611f87974896b3a0b91993d40e882226ea2cc2e3e2bec30));
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
            Proof memory proof, uint[81] memory input
        ) public view returns (bool r) {
        uint[] memory inputValues = new uint[](81);
        
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
