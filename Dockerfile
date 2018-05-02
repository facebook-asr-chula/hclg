FROM dtjones/speech-recognition

MAINTAINER Kris Kalavantavanich

WORKDIR /kaldi/egs/librispeech/s5

## Layer Get Acoustic Model
# 2017 Acoustic Model
# RUN wget https://github.com/ekapolc/ASR_classproject/raw/master/scripts/AM.tar.gz

# 2016 Acoustic Model
RUN wget https://github.com/ekapolc/ASR_classproject/raw/2146262fa51b0a157b3a82c76cb902d4ba9d3657/scripts/AM.tar.gz

RUN tar -xzf AM.tar.gz
RUN rm -rf AM.tar.gz
RUN wget https://raw.githubusercontent.com/ekapolc/ASR_classproject/master/scripts/prepare_LG.sh
RUN chmod 755 prepare_LG.sh

## Layer - Prepare Data
COPY ./data ./data
WORKDIR /kaldi/egs/librispeech/s5/data 
RUN ./prepare_data.sh
WORKDIR /kaldi/egs/librispeech/s5

# Layer - Misc
COPY . .

ENTRYPOINT /bin/bash