# Benchmarking

This page shows the **performance results** of CLP(Q,R) and Linprog based on the execution of the selected standard benchmarks, and available test suites.

## Hardware

The benchmarks' instances and test suites were run on a machine with [this specifications](./hardware.md)

## Method
The benchmarking process has been automated to ease its execution and replicability. 

We provide [guidelines](../docs/run-benchmark-instance.md) to reproduce this process.

The execution time of each instance is measured from the moment the SWI-Prolog process is invoked. This measurement therefore includes not only the start-up of SWI-Prolog itself but also the loading of the chosen library (e.g. clpq.pl, clpr.pl, linprogq.pl, or linprogr.pl) required to perform the computation of the instance.

## Results

Below, you can find pairwise comparisons between: (a) CLP(Q) and Linprogq, and (b) CLP(R) and Linprogr, for the MIPLIB and Netlib benchmarks, as well as for our test suites.
 
**Summary:** Linprog is either faster than CLP(Q,R) or of the same order of magnitude. This means there is no performance degradation when using Linprog.

### MIPLIB

- Time limit (TL): 3000s, Memory limit (ML): 50 GB
- [Dataset CLP(Q) vs Linprogq](../benchmarking/benchmarking-results/benchmark-MIPLIB-results-clpq-vs-linprogq.csv)
- [Dataset CLP(R) vs Linprogr](../benchmarking/benchmarking-results/benchmark-MIPLIB-results-clpr-vs-linprogr.csv)
- [Horizontal bar chart Linprogq vs. CLP(Q)](../benchmarking/graphs/MIPLIB-linprogq-vs-MIPLIB-clpq.svg) 
- [Horizontal bar chart Linprogr vs. CLP(R)](../benchmarking/graphs/MIPLIB-linprogr-vs-MIPLIB-clpr.svg) 


| Instance            | Result               | Time (s)| Result        | Time (s) |
|--------------------|--------------------|--------|--------------------|--------|
|| CLP(Q)               | | Linprogq                | |
markshare_4_0        |1|1188,945|1|465,484
neos859080           | false                |16,548| false                |2,175
neos-3046615-murg    | TIMEOUT              |3001,007|484|131,044
eil33-2              | TIMEOUT              |3001,029|934,007916|293,743
qap10                | TIMEOUT              |3001,010| TIMEOUT              |3001,011
app1-1               | TIMEOUT              |3001,005| TIMEOUT              |3001,006
hypothyroid-k1       | TIMEOUT              |3001,024| TIMEOUT              |3001,017
swath1               | Memory Limit         |574,963| Memory Limit         |663,705
rmatr100-p10         | TIMEOUT              |3001,027| TIMEOUT              |3001,024
dano3_3              | TIMEOUT              |3001,012| TIMEOUT              |3001,011
dano3_5              | TIMEOUT              |3001,011| TIMEOUT              |3001,015
neos-3083819-nubu    | TIMEOUT              |3001,016| Memory Limit         |996,328
decomp2              | TIMEOUT              |3001,008| TIMEOUT              |3001,009
irp                  | TIMEOUT              |3001,052|12159,492836 |985,057
momentum1            | TIMEOUT              |3001,024| TIMEOUT              |3001,016
neos-1122047         | TIMEOUT              |3001,024| TIMEOUT              |3001,024
neos-827175          | TIMEOUT              |3001,017| TIMEOUT              |3001,012
neos-2987310-joes    | TIMEOUT              |3001,017| TIMEOUT              |3001,016
neos8                | TIMEOUT              |3001,074| TIMEOUT              |3001,089
neos-957323          | Memory Limit         |2610,112| TIMEOUT              |3001,072
neos-2746589-doon    | Memory Limit         |1469,687| Memory Limit         |1914,659
tbfp-network         | Memory Limit         |2140,047| Memory Limit         |2228,784
nw04                 | Memory Limit         |1082,653| Memory Limit         |2956,000



| Instance            | Result               | Time (s)| Result        | Time (s) |
|--------------------|--------------------|--------|--------------------|--------|
|| CLP(R)               | | Linprogr                | |
markshare_4_0|1,0000000000009024|910,268|1|467,918
neos859080|false|55,620|false|62,373
neos-3046615-murg|TIMEOUT|3001,007|484|141,591
eil33-2|TIMEOUT|3001,030|934,007916|301,886
qap10|TIMEOUT|3001,009|TIMEOUT|3001,011
app1-1|TIMEOUT|3001,007|TIMEOUT|3001,006
hypothyroid-k1|TIMEOUT|3001,012|TIMEOUT|3001,017
swath1|Memory Limit|513,236|Memory Limit|529,610
rmatr100-p10|TIMEOUT|3001,024|TIMEOUT|3001,024
dano3_3|TIMEOUT|3001,011|TIMEOUT|3001,011
dano3_5|TIMEOUT|3001,011|TIMEOUT|3001,015
neos-3083819-nubu|TIMEOUT|1674,579|Memory Limit|968,505
decomp2|TIMEOUT|3001,009|TIMEOUT|3001,009
irp|TIMEOUT|3001,058|12159,492836000001|859,863
momentum1|TIMEOUT|3001,016|TIMEOUT|3001,016
neos-1122047|TIMEOUT|1573,479|TIMEOUT|3001,024
neos-827175|TIMEOUT|3001,024|TIMEOUT|3001,012
neos-2987310-joes|TIMEOUT|3001,015|TIMEOUT|3001,016
neos8|TIMEOUT|745,803|TIMEOUT|3001,089
neos-957323|Memory Limit|2450,988|TIMEOUT|3001,072
neos-2746589-doon|Memory Limit|780,131|Memory Limit|1957,023
tbfp-network|Memory Limit|2789,034|Memory Limit|2179,744
nw04|TIMEOUT|842,594|TIMEOUT|3001,072


### Netlib

- Time limit (TL): 3000s, Memory limit (ML): 50 GB
- [Dataset CLP(Q) vs. Linprogq](../benchmarking/benchmarking-results/benchmark-netlib-results-clpq-vs-linprogq.csv)
- [Dataset CLP(R) vs. Linprogr](../benchmarking/benchmarking-results/benchmark-netlib-results-clpr-vs-linprogr.csv)
- [Horizontal bar chart Linprogq vs. CLP(Q)](../benchmarking/graphs/netlib-linprogq-vs-netlib-clpq.svg) 
- [Horizontal bar chart Linprogr vs. CLP(R)](../benchmarking/graphs/netlib-linprogr-vs-netlib-clpr.svg) 

| Instance            | Result               | Time (s)| Result        | Time (s) |
|--------------------|--------------------|--------|--------------------|--------|
|| CLP(Q)               | | Linprogq                | |
afiro                |-464,7531429|0,145|-464,7531429|0,17
kb2                  |-1749,90013|0,583|-1749,90013|0,478
sc50a                |-64,57507706|0,138|-64,57507706|0,157
sc50b                |-70|0,151|-70|0,171
adlittle             |225494,9632|1,001|225494,9632|0,709
share2b              |-415,7322407|1,926|-415,7322407|1,706
sc105                |-52,20206121|0,257|-52,20206121|0,229
stocfor1             |-41131,97622|1,1|-41131,97699|1,053
scagr7               |-2331389,824|0,265|-2331389,824|0,282
israel               |-896644,8219|61,176|-896644,8219|63,403
recipelp             |-266,616|0,326|-266,616|0,386
share1b              |-76589,31858|34,582|-76589,31858|25,598
sc205                |-52,20206121|0,59|-52,20206121|0,475
beaconfd             |33592,48581|0,591|33592,48581|0,71
lotfi                |-25,26470606|1,23|-25,26470628|0,395
vtp-base             |129831,4625|0,206|129831,4625|0,256
brandy               |1518,509896|124,629|1518,509894|85,578
e226                 |-18,75192907|1179,505|-18,75192982|1043,913
bore3d               |1373,080394|7,713|1373,080394|7,94
grow7                |-47787811,81|762,962|-47787811,81|151,425
capri                |2690,012914|13,637|2690,012855|8,609
scorpion             |1878,124823|0,572|1878,124823|0,529
bandm                |-158,6280185|236,335|-158,6280174|283,043
sctap1               |1412,25|3,11|1412,25|0,754
scfxm1               |18416,75903|36,433|18416,75903|21,717
agg2                 |-20239252,36|44,301|-20239252,36|44,628
agg3                 |10312115,94|61,748|10312115,94|59,212
stair                | TIMEOUT              |3001,007|-251,2669514|2220,527
scsd1                |8,666666674|640,177|8,666669542|1,407
scagr25              |-14753433,06|3,587|-14753433,06|1,327
degen2               |-1435,178|12,901|-1435,178|10,32
finnis               |172791,0656|41,023|172791,0656|5,918
etamacro             |-755,7152334|18,856|-755,7152958|11,324
fffff800             |555679,5648|1072,678|555679,5685|1058,741
standata             |1257,6995|3,298|1257,6995|1,428
grow15               | Memory Limit         |1337,427| Memory Limit         |1340,87
pilot4               | TIMEOUT              |3001,007| TIMEOUT              |3001,008
scfxm2               |36660,26156|214,82|36660,26156|65,168
standmps             |1406,0175|6,337|1406,0175|5,731
standgub             |1257,6995|3,338|1257,6995|1,58
scrs8                |904,2969538|177,859|904,2970875|106,937
bnl1                 |1977,629562|1254,752| Memory Limit         |708,432
ship04s              |1798714,7|2,599|1798715,837|2,362
fit1d                | Memory Limit         |522,606| Memory Limit         |578,215
perold               | TIMEOUT              |3001,008| TIMEOUT              |3001,008
grow22               | Memory Limit         |1542,49| Memory Limit         |1568,302
maros                | TIMEOUT              |3001,009| TIMEOUT              |3001,008
modszk1              | TIMEOUT              |3001,017| Memory Limit         |1709,464
scfxm3               |54901,25455|543,725|54901,25455|192,062
25fv47               | TIMEOUT              |3001,008| TIMEOUT              |3001,008
shell                |1208825346|3,488|1208825346|1,944
ship04l              |1793324,538|6,179|1793324,924|5,72
wood1p               | Memory Limit         |2307,741| Memory Limit         |637,218
sctap2               |1724,807143|359,038|1724,807143|10,636
scsd8                | Memory Limit         |838,119|904,9999925|29,652
ship08s              |1920098,211|8,543|1920096,661|5,554
pilot-ja             | TIMEOUT              |3001,008| TIMEOUT              |3001,008
degen3               |-987,294|797,454|-987,294|553,693
ganges               |-109585,7361|10,19|-109585,7361|3,241
pilotnov             | TIMEOUT              |3001,009| TIMEOUT              |3001,009
pilot-we             | TIMEOUT              |3001,009| TIMEOUT              |3001,009
ship12s              |1489236,134|5,924|1489247,282|4,623
sctap3               |1424|342,888|1424|17,865
stocfor2             | TIMEOUT              |3001,007| Memory Limit         |991,94
czprob               |2185196,699|303,323|2185196,699|175,091
cycle                | TIMEOUT              |3001,007| TIMEOUT              |3001,008
ship08l              |1909055,211|41,655|1909053,793|25,698
bnl2                 | TIMEOUT              |3001,009| Memory Limit         |641,854
pilot                | TIMEOUT              |3001,011| TIMEOUT              |3001,015
ship12l              |1470187,919|30,001|1470199,04|27,543
d6cube               | TIMEOUT              |3001,011| Memory Limit         |521,212
d2q06c               | TIMEOUT              |3001,008| TIMEOUT              |3001,008
greenbeb             | TIMEOUT              |3001,008| TIMEOUT              |3001,009
greenbea             | TIMEOUT              |3001,008| TIMEOUT              |3001,008
pilot87              | TIMEOUT              |3001,017| TIMEOUT              |3001,015
woodw                | TIMEOUT              |3001,01| Memory Limit         |804,178
truss                | Memory Limit         |930,982|458815,8472|267,847
maros-r7             | TIMEOUT              |3001,025| TIMEOUT              |3001,039
80bau3b              | Memory Limit         |2176,205|987224,1925|1439,894
fit2d                | Memory Limit         |586,266| Memory Limit         |729,424
fit2p                | TIMEOUT              |3001,008| TIMEOUT              |3001,009
qap15                | TIMEOUT              |3001,043| TIMEOUT              |3001,016



| Instance            | Result               | Time (s)| Result        | Time (s) |
|--------------------|--------------------|--------|--------------------|--------|
|| CLP(R)               | | Linprogr               | |
afiro|-464,7531428571427|0,158|-464,7531428571429|0,167
kb2|-1749,9001405761614|0,378| TBC*|TBC*
sc50a|-64,57507705856452|0,161|-64,57507705856453|0,148
sc50b|-69,99999999999997|0,130,-70|0,136
adlittle|225459,27419262036|1,650|225494,96316237803|0,530
share2b|-434,93069240099896|2,026|-415,73224074141876|0,919
sc105|-52,20206121170716|0,202|-52,202061211707225|0,210
stocfor1|-41131,97620556398|0,880|-41131,976987374204|0,632
scagr7|-2331389,8243309734|0,235|-2331389,8243309893|0,249
israel|-893226,8171324311|92,077|TBC*|TBC*
recipelp|-266,61600000000027|0,250|-266,616|0,284
share1b|-76602,54095619523|30,375|-76589,31857918565|16,935
sc205|-52,20206121171731|0,426|-52,202061211707225|0,429
lotfi|-25,264706062018497|1,531|-25,264706280400016|0,390
vtp-base|129831,46246136203|0,188|129831,46246136139|0,212
capri|2688,808689738894|54,727|2690,0128547983786|21,361
scorpion|1878,124822737323|0,500|1878,1248227381059|0,424
bandm|-156,00552399739925|375,259|TBC*|TBC*
sctap1|Memory Limit|450,676|1412,25|0,891
fffff800|TIMEOUT|3001,007|TIMEOUT|3001,007
standata|1257,699499999933|3,030|1257,6995|1,389
grow15|Memory Limit|1104,688|Memory Limit|1229,793
standmps|1406,0175000000024|6,179|1406,0175000000002|5,284
standgub|1257,699499999933|3,054|1257,6995|1,429
scrs8|TIMEOUT|3001,007|TIMEOUT|3001,007
ship04s|1798714,7004453926|2,452|1798715,83699473|2,295
fit1d|Memory Limit|361,126|Memory Limit|397,773
grow22|Memory Limit|2014,589|Memory Limit|2242,368
maros|TIMEOUT|3001,008|TBC*|TBC*
modszk1|TIMEOUT|3001,008|TIMEOUT|3001,015
shell|1208825346,0|3,511|1208825346|2,070
ship04l|1793324,5379703564|6,104|1793324,9239750316|5,826
wood1p|TIMEOUT|3001,011|Memory Limit|446,297
sctap2|TIMEOUT|3001,008|TIMEOUT|3001,008
scsd8|Memory Limit|457,394|904,9999925464408|14,551
ship08s|1920098,2098509467|8,002|1920096,661406591|5,467
ganges|-109585,73612927759|8,756|-109585,73612927829|3,075
ship12s|1489236,1344061305|5,761|1489247,281782113|4,486
sctap3|TIMEOUT|3001,008|TIMEOUT|3001,008
stocfor2|TIMEOUT|3001,008|TIMEOUT|3001,016
czprob|Memory Limit|414,915|2185196,6988565773|148,111
ship08l|1909055,2106146417|39,587|1909053,793353505|24,465
ship12l|1470187,9193292654|29,931|1470199,040143467|27,126
d6cube|TIMEOUT|3001,009|TIMEOUT|336,930
greenbeb|TIMEOUT|3001,011|TBC*|TBC*
woodw|TIMEOUT|3001,015|Memory Limit|711,232
truss|TIMEOUT|3001,011|458815,84718561696|875,908
maros-r7|TIMEOUT|3001,015|TIMEOUT|3001,017
fit2d|Memory Limit|491,374|Memory Limit|595,770
fit2p|TIMEOUT|3001,009|TIMEOUT|3001,009
qap15|TIMEOUT|3001,024|TIMEOUT|3001,015

**TBC***: this instance surfaces the problem we found with CLP(R) ``{}/1`` and duly reported [HERE](known-failures.md). As Linprog(R) implementation of ``{}/1`` makes use of CLP(R)'s, the instance also exposes how the problem appears in Linprog(R). 

### Test suites

- Time limit (TL): 20s, Memory limit (ML): 1 GB
- [CLP test suite - Horizontal bar chart Linprogq vs. CLP(Q)](../tests/graphs/clp-linprogq-vs-clp-clpq.svg) 
- [CLP test suite - Horizontal bar chart Linprogr vs. CLP(R)](../tests/graphs/clp-linprogr-vs-clp-clpr.svg)
- [Cardinality test suite - Horizontal bar chart Linprogq vs. CLP(Q)](../tests/graphs/card-linprogq-vs-card-clpq.svg)
- [Intervals test suite - Horizontal bar chart Linprogq vs. CLP(Q)](../tests/graphs/int-linprogq-vs-int-clpq.svg) 



| Test suite | # Test cases  | CLP(Q) time (s)| Linprogq time (s) | CLP(R) time (s)| Linprogr time (s) | 
|--------------------|--------------------|--------------|--------------|--------------|--------------|
| clp | 69 | 126 | 70 | 115 | 70 |
| cardinality | 470 | 2410 | 2615 | NA | NA |
| intervals | 748 | 385 | 809 | NA | NA |

