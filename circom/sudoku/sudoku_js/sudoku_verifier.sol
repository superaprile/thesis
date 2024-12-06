// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 21831939258354043381489520425617243776712341976176943435781017671429470667759;
    uint256 constant alphay  = 19527029704685172077724758496313576537880427496411015152962440338276179294930;
    uint256 constant betax1  = 17663256537460457936418034858275393554603171651591443871787500264117425883574;
    uint256 constant betax2  = 5798234947870317207219097475207192759778893759412346971099650050729333762876;
    uint256 constant betay1  = 2918955605778536468747218760004689480307822059445227209540197265961075248232;
    uint256 constant betay2  = 15865998950981050189136061515626228110708309636898026179948657568401313131430;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 21817778405161560368397327821801513031622292001381606303499691911682372836851;
    uint256 constant deltax2 = 14565170080849532973623695802253598544043470547395006344151227940906096035505;
    uint256 constant deltay1 = 19874567739236538334430228799382834429868019881914411425772753732533330301230;
    uint256 constant deltay2 = 1322619023184563896330678883727827005347956787442510675865643320019614990346;

    
    uint256 constant IC0x = 5752319885206920736158156580334824690030483488224774180004040717490625508276;
    uint256 constant IC0y = 19843900349766433539945499221624781210222486505095437384564689442067584104340;
    
    uint256 constant IC1x = 14089239585665040895272364845992045553857023740483857187544369804446850767358;
    uint256 constant IC1y = 2381095386439066314812693403409005882360799014614052795371001529213228528062;
    
    uint256 constant IC2x = 20300067932524195009105060130257412859103269667705090983362854512714218861251;
    uint256 constant IC2y = 261009193955511620013108513174971282693184499838292155792799850808444644062;
    
    uint256 constant IC3x = 12232792299707776734594020033868963928298811981730584911494528704598471374940;
    uint256 constant IC3y = 4403245090081897528355107440709738750979218260351015928520465622326911378900;
    
    uint256 constant IC4x = 10797562457903601413542420549362594422453414438056467278510877477114653870657;
    uint256 constant IC4y = 11897646240879161217757621534492701200402056187827388952924955398166791961488;
    
    uint256 constant IC5x = 8897646291410078535340225982597087177074049904522567526738328342206415753047;
    uint256 constant IC5y = 18753358712131320873684075630432421048574715948804798955199993515690129729184;
    
    uint256 constant IC6x = 11168089186929207507321529845650768128362153776725426645404814889361346653137;
    uint256 constant IC6y = 21135155111057399213973273695827232982259326539795887233637956714804321352082;
    
    uint256 constant IC7x = 6619627780710633461992754854182039599028593328067008447117482965237318599830;
    uint256 constant IC7y = 5705423212920954247376630690146371375621133809895359598761042131366548422498;
    
    uint256 constant IC8x = 13683320798635662642307987958033551492928933356787839038974086457218091936269;
    uint256 constant IC8y = 776208787155598776116090092267804050682838799927186202045622604959683049527;
    
    uint256 constant IC9x = 12259722579991553692054467736901395462352316105940485526879501542039809099923;
    uint256 constant IC9y = 7514005738282045961346455792513370571963708051727096077521770646910145683652;
    
    uint256 constant IC10x = 9446083854210154952433554853349473742839197155939607793095109301524699909799;
    uint256 constant IC10y = 5777708642075587987959632888592635510879790342867694426395356685608410090112;
    
    uint256 constant IC11x = 10547768953311203275951040955489653855091656907971410878999808133312835561423;
    uint256 constant IC11y = 19264051509866325404410384607339568681550451290131066471850997593739332581449;
    
    uint256 constant IC12x = 6251312294978675830584587238811135297136003024911920194376741046233544861674;
    uint256 constant IC12y = 8689501384536097711724192019328190933381031417516060157860224568579085275194;
    
    uint256 constant IC13x = 3148689825031026980998242931635015618264741353872963095702433428899197563974;
    uint256 constant IC13y = 3069162502448182059639873679297034171487341704158776602051929848011429166206;
    
    uint256 constant IC14x = 2675572398411562033003315641804134975597561317422023460432232883847296674396;
    uint256 constant IC14y = 3803830104137959629571453055429593042070667251546629816223390769705420725451;
    
    uint256 constant IC15x = 10936649925194880451726917888801319095614427997092069995286893643310407203828;
    uint256 constant IC15y = 5692273691425023599259231923424154310251160569903765789062877131638751484053;
    
    uint256 constant IC16x = 6966800562693735320695499656388908241753706993782492723923025806589673684905;
    uint256 constant IC16y = 3223258303069275098730091686033821712025739763374591386609526450543282438654;
    
    uint256 constant IC17x = 4139426506242235578199190332694532113564272181084605674476072350281326376816;
    uint256 constant IC17y = 17572174844350931920840021665524095262927472146685203091819350315678956073314;
    
    uint256 constant IC18x = 19538073032527005917976867446398555982081038472358927071894157609513541952544;
    uint256 constant IC18y = 9307305990712517728520974464109009228265496292288846550216890479826358458384;
    
    uint256 constant IC19x = 8242091215059398068814637728465664903710564118724255084686323336383184296467;
    uint256 constant IC19y = 10273086358670407721614337819381951893570955076695636771942945120236665270117;
    
    uint256 constant IC20x = 14820023696550035859153491188252142923743030189774764977853040714139973155616;
    uint256 constant IC20y = 1136255253287135242262273414887518121352656526672142396536108708730582240344;
    
    uint256 constant IC21x = 14102131245804802988933437642762747810387549851925965911210224871194218875642;
    uint256 constant IC21y = 10810096358021013718827802478983545852756711750519636639459896047407703100646;
    
    uint256 constant IC22x = 12356169301176476589853456460109433509686675080477365034428679850764533054004;
    uint256 constant IC22y = 6256241346875189525286877666244682029239621248562812707560930760361865100970;
    
    uint256 constant IC23x = 20740475927545535009249060998192449086856087669926271474434362851107526805298;
    uint256 constant IC23y = 10659396802868030659825362490911583467233908371958110892604093568731438096529;
    
    uint256 constant IC24x = 6915235308810331231174369961025831992148588241880393075255502167498753165452;
    uint256 constant IC24y = 13715537781283567411966538688201090241807354273291960501653052155381007530200;
    
    uint256 constant IC25x = 8173359422435309139211084909006080495505655885147049710103110047956420377602;
    uint256 constant IC25y = 5166015833051569829013441962158638509097285679468873936175772671176566712057;
    
    uint256 constant IC26x = 7576553167208030598384337890634786321444691102692660409382968485359643400859;
    uint256 constant IC26y = 16574913687345020767882417039280880570562030472155809061138815149141241304886;
    
    uint256 constant IC27x = 11556962698488486903410381196498690743014340246707733785405627291526412751586;
    uint256 constant IC27y = 5674836689871968598396794838340878772393378609961076480489330771348547916927;
    
    uint256 constant IC28x = 2805597348463032906976662071572108814257242028821080781027935357740703142703;
    uint256 constant IC28y = 10311322093119567616840887221891733166525115714090441196442335664129544496908;
    
    uint256 constant IC29x = 11312597938027860708593359416484378505988307396227004463878801080307319982489;
    uint256 constant IC29y = 2435234954866184114204220974482386966963384220004011842798833744155062048604;
    
    uint256 constant IC30x = 19216903478205019191921137297401061616076179856167924234139196810280203507674;
    uint256 constant IC30y = 17575367525391532190383125458057963483521604232127859540842631190106238246073;
    
    uint256 constant IC31x = 5772077937311398303705802668966351825671356653148276494592983301411029271915;
    uint256 constant IC31y = 15754204896786672955314893819612160582850065547422026526633016947744452547506;
    
    uint256 constant IC32x = 6145724887954749116047633170476268077498688262989548779743372590194895954550;
    uint256 constant IC32y = 10399013818555386530661483482780871564549599388762464247535658314176511358569;
    
    uint256 constant IC33x = 4539771394925791131822981278059013590463206038810990881192282966060925047163;
    uint256 constant IC33y = 6468406873159071961053038562363835541037665421004406070285074750007660545637;
    
    uint256 constant IC34x = 11907337605087570006497678993784878893817418868136149778049037654037887980984;
    uint256 constant IC34y = 19266981816830095764680111010461507455325439219946746439450763881629255041834;
    
    uint256 constant IC35x = 12490645523169241551937283175516884694084362682190347183850622154795678225294;
    uint256 constant IC35y = 3519820210844690515363338046182633537664962014446474224480251027094828282271;
    
    uint256 constant IC36x = 10475101841422487073973349070465881275974654021638286836129418109721360045464;
    uint256 constant IC36y = 20142446868969904006948167329710898198653117975427238955346303987855903705207;
    
    uint256 constant IC37x = 18795537891738266382564940974543423319474767182231278765129443549660441804217;
    uint256 constant IC37y = 9177683897540475531451041360640534217913628420578421922348335635843804308883;
    
    uint256 constant IC38x = 3931913840502326371898205899199225835075680197556069464109964040446488047326;
    uint256 constant IC38y = 16184112408885226206315972424626544326348459092495388904600794154894085410764;
    
    uint256 constant IC39x = 6997861518820843412713827919495794754950665833331844855341954136686219899241;
    uint256 constant IC39y = 2190534853851032051845997326307107710249560449615720874110187684715376636222;
    
    uint256 constant IC40x = 10772472556806120454901381283001803632331673835031437744993707933009148234921;
    uint256 constant IC40y = 8346940854291766762669666123469139787966168680651833491772477358388890540305;
    
    uint256 constant IC41x = 18946093989427651484700477525490494136518627352056035007849707511449924852605;
    uint256 constant IC41y = 17294496968914693456827644032197317011789963374588950641807421806548664937587;
    
    uint256 constant IC42x = 16966312032386211409422787500864052204979666487152873007870870253259777063453;
    uint256 constant IC42y = 16081000653549056500243136058866267186938878352301871417896169230178658119531;
    
    uint256 constant IC43x = 3941465324708760020406552342984689196713870811504262947796325294363933587506;
    uint256 constant IC43y = 14671078495833518262563605720044321558921765735889605842960896263703210262136;
    
    uint256 constant IC44x = 17793946823306267293282781009807780534695331049656440569216573840206372059369;
    uint256 constant IC44y = 17087379948741968970556210777475766216324419773699620630739229097622739502732;
    
    uint256 constant IC45x = 10914302090119359631353944991041394606500621653409753559363223620765404130886;
    uint256 constant IC45y = 16537870263912899002706008569548277590813125318436372767685460905991788652181;
    
    uint256 constant IC46x = 12749456329718565139308995684666502265630297060405194133093308401001604998362;
    uint256 constant IC46y = 19343033120541666329911688854962889267896387154673692554638639096896269583320;
    
    uint256 constant IC47x = 8487497890258644924626991833615248422889265655182196918487034525701862132814;
    uint256 constant IC47y = 16367889751589415174584413210329761096354245356531246263153664394473597473748;
    
    uint256 constant IC48x = 2990783340280124509409868788142335831670342136862373581542791209697066110878;
    uint256 constant IC48y = 7956423009596158130138999049459667300097930559973516696676035760415119979049;
    
    uint256 constant IC49x = 12393541010917984894886998164643379772102372093533884801266831541533069036682;
    uint256 constant IC49y = 16199257573531799314945477804106541071060916399362958040056827818646722520364;
    
    uint256 constant IC50x = 14036831833132778945617384120725480557802170585351691873061557923297172667596;
    uint256 constant IC50y = 8109939112847259606964854605250298341310240443929832906776011822869262569437;
    
    uint256 constant IC51x = 21624286078547951046691831188783811199317291741595417184292787464520283008108;
    uint256 constant IC51y = 16820337077880850200013893349135678374920017446357003257696697341587578382929;
    
    uint256 constant IC52x = 416677688098358728776644851532187396447578323213484740773257193336698142793;
    uint256 constant IC52y = 19693811674615467589062368604257311400390691110592662421940666339108459754666;
    
    uint256 constant IC53x = 8635610687689312460200733424021161521641543881827243385779522389628574595211;
    uint256 constant IC53y = 5023021378509395110253688275864871312108143074548454525621651208474579872672;
    
    uint256 constant IC54x = 9497692892551802491520151455307800022276365598866539025969978164236560821576;
    uint256 constant IC54y = 10818566873418552751425836876495120723419793775477122134973103928577203351318;
    
    uint256 constant IC55x = 17735094660362389114237315941923545235948907472551953904956228298100234785836;
    uint256 constant IC55y = 21605426830828085157372128925683385916891691858649721433591079094307814355881;
    
    uint256 constant IC56x = 12101971060740856091885084067119938288815454359059496961996989851051298262938;
    uint256 constant IC56y = 10222988754647749001705876671353569223185469942182744814460639381511910137410;
    
    uint256 constant IC57x = 16580579892178680400618133789884638066948118004765900112205654149188383122962;
    uint256 constant IC57y = 4732596643152435506580531078132791778675367303870752877304786322702071519111;
    
    uint256 constant IC58x = 11642590755030466827745158465974628464768093797774308493650483692871824930997;
    uint256 constant IC58y = 20845593566198836258490656559533961715941254858520017235773633105473092743040;
    
    uint256 constant IC59x = 12864260665011604046640430845003197262388807484445367434262534979743188770;
    uint256 constant IC59y = 3866056737285082036542084519516581835190480742365070538168882196431403892595;
    
    uint256 constant IC60x = 15065082852529936809020668557497578330496737452792006087706477061854101888231;
    uint256 constant IC60y = 7079509552797940536465667183425796765911385686316122621456891782349235306295;
    
    uint256 constant IC61x = 404989531758871329808016393934236487775407912580215597700447208040502269369;
    uint256 constant IC61y = 14213088689339326442450901960488734518742450709470564376915830420035735449840;
    
    uint256 constant IC62x = 20806336111842436443343083671973751207992935444432046271587344894391838317662;
    uint256 constant IC62y = 11323428044370334631324353796888313544110548708866653401124874915942359029781;
    
    uint256 constant IC63x = 16766961123708636053231662883021978127621969389722729995705045695897339947299;
    uint256 constant IC63y = 17121287275882607570643664278616141634061078088111740545742844800346498686383;
    
    uint256 constant IC64x = 18974910561926705186945125052612127970667713640456830458447408805039912138597;
    uint256 constant IC64y = 376629682648629611754498500788384411977844559421407112516073765867364163806;
    
    uint256 constant IC65x = 21292052052584699258650125151980023463156878860288902978267857606676074364905;
    uint256 constant IC65y = 8379760827623323734152592893087655652875918688733941469425307143011456058292;
    
    uint256 constant IC66x = 12185371116954853497604909854028490772072187746105554254966129443883847024789;
    uint256 constant IC66y = 1721702013366282245899098976312386208844289200137737561636573947778244350732;
    
    uint256 constant IC67x = 2748809453277775860986400376744041238964789873155977757422588982382487763829;
    uint256 constant IC67y = 9910564494842181106352295370899019433287995169892162552868319927798443887406;
    
    uint256 constant IC68x = 6304855825521695769968188739740303768738752338108798095408975191508679558486;
    uint256 constant IC68y = 13843564073874227748812247761172277485269456302104161530549098508914474260844;
    
    uint256 constant IC69x = 3580463860871786926256850587683917773085735293020916903262820672594702223709;
    uint256 constant IC69y = 2097464696619312816003845115457797710250268283547609220652053862287094576066;
    
    uint256 constant IC70x = 6777656714381237145279430454811907440043276903630082049945555264120515551801;
    uint256 constant IC70y = 16228902881311144989376139613785088112552430427743828140096728482900647125079;
    
    uint256 constant IC71x = 14672234363907609343826433585568993670876902009296572181589081405727849645056;
    uint256 constant IC71y = 1299417247671349484785796253351010351163696620416748641485590514184730554561;
    
    uint256 constant IC72x = 21164649724227204195225336057515102309890202122083434968187743802809116324530;
    uint256 constant IC72y = 17384923890092433932189422515233132939346520046371280969847185492604558478679;
    
    uint256 constant IC73x = 7703875775833999523947015070403712699181711206715341991500789302608058922360;
    uint256 constant IC73y = 2410823011130065692441369069027134700333017436364381817188065642429060421560;
    
    uint256 constant IC74x = 7535773949604052159795435219392635822343949319553811843530425433232952192909;
    uint256 constant IC74y = 4152899653912406569766307382602312188499175797217384830905686787802852553324;
    
    uint256 constant IC75x = 3158588368887163194329276445501330690355001570510571323207765657849399399302;
    uint256 constant IC75y = 6674291545284463846774773321024136782462465975742093673957720340755118938387;
    
    uint256 constant IC76x = 8281833771777711458678332974295485402735695329452709172380917948008824988436;
    uint256 constant IC76y = 2139659070589057642369001295475975842254823548315384555978133551514102059730;
    
    uint256 constant IC77x = 12542504165471848969864847354233801463404177286871464841856490571295672657462;
    uint256 constant IC77y = 19404162455522999290728725322456584193373401082077142971437814457760120035687;
    
    uint256 constant IC78x = 2271449025118613090716579616911395500441380209746891260898727611073457121102;
    uint256 constant IC78y = 971261844455767758833140569655366188227128116641541305789961189660612032077;
    
    uint256 constant IC79x = 4320318950667990099446279960889770060320769473469431634864480252682005577518;
    uint256 constant IC79y = 13357453482468576948398718315052793722276636579161018642266221574811356381259;
    
    uint256 constant IC80x = 5019345844003037966714799452500595349641308965932545585069909090117009462512;
    uint256 constant IC80y = 3581865425239806970293472331509660163413768119368266846103475096240469065487;
    
    uint256 constant IC81x = 18175282010488840668012263158811017694632782909607412432629468236089371407548;
    uint256 constant IC81y = 2791717676239118271779527477031406291369253504615831965170966014192948811257;
    
    uint256 constant IC82x = 2920029926150747464797429527816116816429471145312121370543850931056400927252;
    uint256 constant IC82y = 20335153020812821765298264121752250737702426078047030292367338208909275157418;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[82] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, r)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                
                g1_mulAccC(_pVk, IC32x, IC32y, calldataload(add(pubSignals, 992)))
                
                g1_mulAccC(_pVk, IC33x, IC33y, calldataload(add(pubSignals, 1024)))
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                
                g1_mulAccC(_pVk, IC35x, IC35y, calldataload(add(pubSignals, 1088)))
                
                g1_mulAccC(_pVk, IC36x, IC36y, calldataload(add(pubSignals, 1120)))
                
                g1_mulAccC(_pVk, IC37x, IC37y, calldataload(add(pubSignals, 1152)))
                
                g1_mulAccC(_pVk, IC38x, IC38y, calldataload(add(pubSignals, 1184)))
                
                g1_mulAccC(_pVk, IC39x, IC39y, calldataload(add(pubSignals, 1216)))
                
                g1_mulAccC(_pVk, IC40x, IC40y, calldataload(add(pubSignals, 1248)))
                
                g1_mulAccC(_pVk, IC41x, IC41y, calldataload(add(pubSignals, 1280)))
                
                g1_mulAccC(_pVk, IC42x, IC42y, calldataload(add(pubSignals, 1312)))
                
                g1_mulAccC(_pVk, IC43x, IC43y, calldataload(add(pubSignals, 1344)))
                
                g1_mulAccC(_pVk, IC44x, IC44y, calldataload(add(pubSignals, 1376)))
                
                g1_mulAccC(_pVk, IC45x, IC45y, calldataload(add(pubSignals, 1408)))
                
                g1_mulAccC(_pVk, IC46x, IC46y, calldataload(add(pubSignals, 1440)))
                
                g1_mulAccC(_pVk, IC47x, IC47y, calldataload(add(pubSignals, 1472)))
                
                g1_mulAccC(_pVk, IC48x, IC48y, calldataload(add(pubSignals, 1504)))
                
                g1_mulAccC(_pVk, IC49x, IC49y, calldataload(add(pubSignals, 1536)))
                
                g1_mulAccC(_pVk, IC50x, IC50y, calldataload(add(pubSignals, 1568)))
                
                g1_mulAccC(_pVk, IC51x, IC51y, calldataload(add(pubSignals, 1600)))
                
                g1_mulAccC(_pVk, IC52x, IC52y, calldataload(add(pubSignals, 1632)))
                
                g1_mulAccC(_pVk, IC53x, IC53y, calldataload(add(pubSignals, 1664)))
                
                g1_mulAccC(_pVk, IC54x, IC54y, calldataload(add(pubSignals, 1696)))
                
                g1_mulAccC(_pVk, IC55x, IC55y, calldataload(add(pubSignals, 1728)))
                
                g1_mulAccC(_pVk, IC56x, IC56y, calldataload(add(pubSignals, 1760)))
                
                g1_mulAccC(_pVk, IC57x, IC57y, calldataload(add(pubSignals, 1792)))
                
                g1_mulAccC(_pVk, IC58x, IC58y, calldataload(add(pubSignals, 1824)))
                
                g1_mulAccC(_pVk, IC59x, IC59y, calldataload(add(pubSignals, 1856)))
                
                g1_mulAccC(_pVk, IC60x, IC60y, calldataload(add(pubSignals, 1888)))
                
                g1_mulAccC(_pVk, IC61x, IC61y, calldataload(add(pubSignals, 1920)))
                
                g1_mulAccC(_pVk, IC62x, IC62y, calldataload(add(pubSignals, 1952)))
                
                g1_mulAccC(_pVk, IC63x, IC63y, calldataload(add(pubSignals, 1984)))
                
                g1_mulAccC(_pVk, IC64x, IC64y, calldataload(add(pubSignals, 2016)))
                
                g1_mulAccC(_pVk, IC65x, IC65y, calldataload(add(pubSignals, 2048)))
                
                g1_mulAccC(_pVk, IC66x, IC66y, calldataload(add(pubSignals, 2080)))
                
                g1_mulAccC(_pVk, IC67x, IC67y, calldataload(add(pubSignals, 2112)))
                
                g1_mulAccC(_pVk, IC68x, IC68y, calldataload(add(pubSignals, 2144)))
                
                g1_mulAccC(_pVk, IC69x, IC69y, calldataload(add(pubSignals, 2176)))
                
                g1_mulAccC(_pVk, IC70x, IC70y, calldataload(add(pubSignals, 2208)))
                
                g1_mulAccC(_pVk, IC71x, IC71y, calldataload(add(pubSignals, 2240)))
                
                g1_mulAccC(_pVk, IC72x, IC72y, calldataload(add(pubSignals, 2272)))
                
                g1_mulAccC(_pVk, IC73x, IC73y, calldataload(add(pubSignals, 2304)))
                
                g1_mulAccC(_pVk, IC74x, IC74y, calldataload(add(pubSignals, 2336)))
                
                g1_mulAccC(_pVk, IC75x, IC75y, calldataload(add(pubSignals, 2368)))
                
                g1_mulAccC(_pVk, IC76x, IC76y, calldataload(add(pubSignals, 2400)))
                
                g1_mulAccC(_pVk, IC77x, IC77y, calldataload(add(pubSignals, 2432)))
                
                g1_mulAccC(_pVk, IC78x, IC78y, calldataload(add(pubSignals, 2464)))
                
                g1_mulAccC(_pVk, IC79x, IC79y, calldataload(add(pubSignals, 2496)))
                
                g1_mulAccC(_pVk, IC80x, IC80y, calldataload(add(pubSignals, 2528)))
                
                g1_mulAccC(_pVk, IC81x, IC81y, calldataload(add(pubSignals, 2560)))
                
                g1_mulAccC(_pVk, IC82x, IC82y, calldataload(add(pubSignals, 2592)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            
            checkField(calldataload(add(_pubSignals, 384)))
            
            checkField(calldataload(add(_pubSignals, 416)))
            
            checkField(calldataload(add(_pubSignals, 448)))
            
            checkField(calldataload(add(_pubSignals, 480)))
            
            checkField(calldataload(add(_pubSignals, 512)))
            
            checkField(calldataload(add(_pubSignals, 544)))
            
            checkField(calldataload(add(_pubSignals, 576)))
            
            checkField(calldataload(add(_pubSignals, 608)))
            
            checkField(calldataload(add(_pubSignals, 640)))
            
            checkField(calldataload(add(_pubSignals, 672)))
            
            checkField(calldataload(add(_pubSignals, 704)))
            
            checkField(calldataload(add(_pubSignals, 736)))
            
            checkField(calldataload(add(_pubSignals, 768)))
            
            checkField(calldataload(add(_pubSignals, 800)))
            
            checkField(calldataload(add(_pubSignals, 832)))
            
            checkField(calldataload(add(_pubSignals, 864)))
            
            checkField(calldataload(add(_pubSignals, 896)))
            
            checkField(calldataload(add(_pubSignals, 928)))
            
            checkField(calldataload(add(_pubSignals, 960)))
            
            checkField(calldataload(add(_pubSignals, 992)))
            
            checkField(calldataload(add(_pubSignals, 1024)))
            
            checkField(calldataload(add(_pubSignals, 1056)))
            
            checkField(calldataload(add(_pubSignals, 1088)))
            
            checkField(calldataload(add(_pubSignals, 1120)))
            
            checkField(calldataload(add(_pubSignals, 1152)))
            
            checkField(calldataload(add(_pubSignals, 1184)))
            
            checkField(calldataload(add(_pubSignals, 1216)))
            
            checkField(calldataload(add(_pubSignals, 1248)))
            
            checkField(calldataload(add(_pubSignals, 1280)))
            
            checkField(calldataload(add(_pubSignals, 1312)))
            
            checkField(calldataload(add(_pubSignals, 1344)))
            
            checkField(calldataload(add(_pubSignals, 1376)))
            
            checkField(calldataload(add(_pubSignals, 1408)))
            
            checkField(calldataload(add(_pubSignals, 1440)))
            
            checkField(calldataload(add(_pubSignals, 1472)))
            
            checkField(calldataload(add(_pubSignals, 1504)))
            
            checkField(calldataload(add(_pubSignals, 1536)))
            
            checkField(calldataload(add(_pubSignals, 1568)))
            
            checkField(calldataload(add(_pubSignals, 1600)))
            
            checkField(calldataload(add(_pubSignals, 1632)))
            
            checkField(calldataload(add(_pubSignals, 1664)))
            
            checkField(calldataload(add(_pubSignals, 1696)))
            
            checkField(calldataload(add(_pubSignals, 1728)))
            
            checkField(calldataload(add(_pubSignals, 1760)))
            
            checkField(calldataload(add(_pubSignals, 1792)))
            
            checkField(calldataload(add(_pubSignals, 1824)))
            
            checkField(calldataload(add(_pubSignals, 1856)))
            
            checkField(calldataload(add(_pubSignals, 1888)))
            
            checkField(calldataload(add(_pubSignals, 1920)))
            
            checkField(calldataload(add(_pubSignals, 1952)))
            
            checkField(calldataload(add(_pubSignals, 1984)))
            
            checkField(calldataload(add(_pubSignals, 2016)))
            
            checkField(calldataload(add(_pubSignals, 2048)))
            
            checkField(calldataload(add(_pubSignals, 2080)))
            
            checkField(calldataload(add(_pubSignals, 2112)))
            
            checkField(calldataload(add(_pubSignals, 2144)))
            
            checkField(calldataload(add(_pubSignals, 2176)))
            
            checkField(calldataload(add(_pubSignals, 2208)))
            
            checkField(calldataload(add(_pubSignals, 2240)))
            
            checkField(calldataload(add(_pubSignals, 2272)))
            
            checkField(calldataload(add(_pubSignals, 2304)))
            
            checkField(calldataload(add(_pubSignals, 2336)))
            
            checkField(calldataload(add(_pubSignals, 2368)))
            
            checkField(calldataload(add(_pubSignals, 2400)))
            
            checkField(calldataload(add(_pubSignals, 2432)))
            
            checkField(calldataload(add(_pubSignals, 2464)))
            
            checkField(calldataload(add(_pubSignals, 2496)))
            
            checkField(calldataload(add(_pubSignals, 2528)))
            
            checkField(calldataload(add(_pubSignals, 2560)))
            
            checkField(calldataload(add(_pubSignals, 2592)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
