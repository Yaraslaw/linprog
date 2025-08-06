cd Fine-for-testing-MIPLIB

rm test.pl

for i in *.mps; do
    echo "consult('./../transformer.pl')." >> test.pl
    ext="mps"
    bni=${i%.mps}
    echo "parse('./$bni.mps', '$bni.pl')." >> test.pl
    echo "$bni"
    echo "$i"
    echo "$(cat ./test.pl)"
    timeout --foreground 6000s swipl -q < test.pl
    echo ""
    echo ""
    rm test.pl
done


