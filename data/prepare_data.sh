#!/bin/bash
## (C) Kris Kalavantavanich 2018

## Description
## This script generates required files for using Kaldi. 

## File Structure
# .
# ├── dev
# |   ├── spk2utt
# │   ├── text
# │   ├── utt2spk
# │   └── wav.scp
# ├── prepare_data.sh
# ├── script.txt
# └── test
#     ├── spk2utt
#     ├── text
#     ├── utt2spk
#     └── wav.scp

## Configure Inputs
TEST_DIRECTORY=./test
DEV_DIRECTORY=./dev
TRANSCRIPT=script.txt
UTT2SPK_UTIL=/kaldi/egs/yesno/s5/utils/utt2spk_to_spk2utt.pl

## Configure Outputs
TEST_WAV_SCP=$TEST_DIRECTORY/wav.scp
TEST_TEXT=$TEST_DIRECTORY/text
TEST_UTT_SPK=$TEST_DIRECTORY/utt2spk
TEST_SPK_UTT=$TEST_DIRECTORY/spk2utt

DEV_WAV_SCP=$DEV_DIRECTORY/wav.scp
DEV_TEXT=$DEV_DIRECTORY/text
DEV_UTT_SPK=$DEV_DIRECTORY/utt2spk
DEV_SPK_UTT=$DEV_DIRECTORY/spk2utt

## Clean Existing Files
rm -f $TEST_WAV_SCP $DEV_WAV_SCP
rm -f $TEST_TEXT $DEV_TEXT
rm -f $TEST_UTT_SPK $DEV_UTT_SPK
rm -f $TEST_SPK_UTT $DEV_SPK_UTT

## File name regex pattern
## format: <SPK>_<ID>.wav
## ID must have 3 digits
## SPK must contain only alphanumeric characters
fileRegex='('$TEST_DIRECTORY'|'$DEV_DIRECTORY')/(([A-Za-z0-9]+)_([0-9][0-9][0-9]).wav)'

for f in "$TEST_DIRECTORY"/*.wav "$DEV_DIRECTORY"/*.wav
do
    # echo "FILE: "$f
    if [[ $f =~ $fileRegex ]]
    then
        # echo ">> Regex Matched"
        # echo '>> Group 1 =' ${BASH_REMATCH[1]}
        # echo '>> Group 2 =' ${BASH_REMATCH[2]}
        # echo '>> Group 3 =' ${BASH_REMATCH[3]}
        location=${BASH_REMATCH[1]}
        filename=${BASH_REMATCH[2]}
        spk=${BASH_REMATCH[3]}
        id=${BASH_REMATCH[4]}
        ## Write to wav.scp file 
        if [ "$location" == "$TEST_DIRECTORY" ]
        then
            echo $id $PWD/test/$filename >> $TEST_WAV_SCP
            grep $id $TRANSCRIPT >> $TEST_TEXT
            echo $id $spk >> $TEST_UTT_SPK
        elif [ "$location" == "$DEV_DIRECTORY" ]
        then
            echo $id $PWD/dev/$filename >> $DEV_WAV_SCP
            grep $id $TRANSCRIPT >> $DEV_TEXT
            echo $id $PWD/$spk >> $DEV_UTT_SPK
        fi
    else
        echo ">> Regex did not match (File = "$f
    fi
done


## Make SPK2UTT file using utils in Kaldi
if [ -f $UTT2SPK_UTIL ]
then
    $UTT2SPK_UTIL $TEST_UTT_SPK > $TEST_SPK_UTT
    $UTT2SPK_UTIL $DEV_UTT_SPK > $DEV_SPK_UTT
else
    echo "[ERROR] UTT2SPK Utils not found. This code is probably not ran in a Kaldi Docker."
fi