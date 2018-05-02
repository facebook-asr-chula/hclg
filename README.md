## ASR Kaldi (HCLG Assembler)

This Docker contains a script `eval.sh` which can be used to assemble the acoustic model, lexical model, and language model together. This Docker is based on Kaldi, a speech recognition framework. 

### To build

```
docker build -t asr/kaldi .
```

### To run

```
sudo docker run -it -v $(pwd)/models:/kaldi/egs/librispeech/s5/models --rm --name kaldi asr/kaldi
```


