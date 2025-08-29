if [[ -z $1 ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

cd $1
cp ./transformer.pl $1

rm -f test.pl

for i in *.mps; do
    echo "consult('./transformer.pl')." >> test.pl
    ext="mps"
    bni=${i%.mps}
    echo "parse('./$bni.mps', '$bni.pl')." >> test.pl
    echo "$bni"
    echo "$i"
    echo "$(cat ./test.pl)"
    timeout --foreground 6000s swipl -q < test.pl
    echo ""
    echo ""
    rm -f test.pl
done

rm -f ./transformer.pl


