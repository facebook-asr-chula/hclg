#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 <lexicon> <lm>"
  exit 1
fi

lexicon=$1
lm=$2

NUM_JOBS=5

rm -rf data/local/dict data/lang
./prepare_LG.sh $lexicon $lm exp/nnet2_online/phones.txt data/local/dict data/lang
utils/mkgraph.sh data/lang exp/nnet2_online exp/nnet2_online/graph

steps/online/nnet2/decode.sh --config conf/decode.config --cmd utils/run.pl --nj $NUM_JOBS --per-utt true --online true exp/nnet2_online/graph data/dev exp/nnet2_online/decode_dev
steps/online/nnet2/decode.sh --config conf/decode.config --cmd utils/run.pl --nj $NUM_JOBS --per-utt true --online true exp/nnet2_online/graph data/test exp/nnet2_online/decode_test

grep WER exp/nnet2_online/decode_dev/wer_*
utils/int2sym.pl -f 2- exp/nnet2_online/graph/words.txt exp/nnet2_online/decode_dev/scoring/15.0.0.tra

cp ./exp ./models/hclg/ -r 
