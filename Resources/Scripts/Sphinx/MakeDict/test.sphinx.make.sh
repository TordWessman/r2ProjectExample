#!/bin/bash

BASE_DIR=./
LANGUAGE_BASE_NAME=corpus
OUTPUT_BASE_NAME=test2
TARGET_DIR=./

if [ ! -e $BASE_DIR ]; then
	echo "$BASE_DIR does not exist!"
	exit -1
fi

if [ -e $LANGUAGE_BASE_NAME ]; then
	echo "argument 2 - language base name - is not set"
	exit -1
fi;


SPHINX_DIR=$BASE_DIR/resources/sphinx

MARKUP_FILE_NAME=$LANGUAGE_BASE_NAME.txt

echo "--------------text2wfreq-----------------"
text2wfreq < $MARKUP_FILE_NAME | wfreq2vocab > $LANGUAGE_BASE_NAME.vocab
echo ""
echo "--------------text2idngram-----------------"
text2idngram -vocab $LANGUAGE_BASE_NAME.vocab -idngram $LANGUAGE_BASE_NAME.idngram < $MARKUP_FILE_NAME
#text2idngram -vocab $LANGUAGE_BASE_NAME.vocab -idngram $LANGUAGE_BASE_NAME.idngram -write_ascii < $MARKUP_FILE_NAME > $LANGUAGE_BASE_NAME.idngram

echo ""
echo "--------------idngram2lm-----------------"
idngram2lm -vocab_type 0 -idngram $LANGUAGE_BASE_NAME.idngram -vocab $LANGUAGE_BASE_NAME.vocab -arpa $LANGUAGE_BASE_NAME.unsorted.arpa -good_turing -disc_ranges 0 0 0
#idngram2lm  -idngram $LANGUAGE_BASE_NAME.idngram -vocab $LANGUAGE_BASE_NAME.vocab  -arpa $LANGUAGE_BASE_NAME.unsorted.arpa -context $LANGUAGE_BASE_NAME.ccs -vocab_type 0 -good_turing -disc_ranges 0 0 0 -ascii_input

#OLD: sphinx_lm_convert -i $LANGUAGE_BASE_NAME.arpa -o $LANGUAGE_BASE_NAME.lm.DMP
echo ""
echo "---------------sphinx_lm_sort----------------"
sphinx_lm_sort < $LANGUAGE_BASE_NAME.unsorted.arpa > $LANGUAGE_BASE_NAME.arpa
echo ""
echo "-----------------sphinx_lm_convert--------------"
sphinx_lm_convert -i $LANGUAGE_BASE_NAME.arpa -o $LANGUAGE_BASE_NAME.dmp

echo ""
echo "-----------------sphinx_lm_convert: create .lm:--------------"
sphinx_lm_convert -i $LANGUAGE_BASE_NAME.dmp -ifmt dmp -o $OUTPUT_BASE_NAME.lm -ofmt arpa

echo "... done"
echo "-----------------make_pronunciation.pl--------------"
#perl make_pronunciation.pl -tools .. -dictdir ./ -words $LANGUAGE_BASE_NAME.vocab -handdict $LANGUAGE_BASE_NAME.hand.dict -dict $LANGUAGE_BASE_NAME.dict
perl make_pronunciation.pl -tools .. -dictdir ./ -words words.txt -handdict $OUTPUT_BASE_NAME.hand.dict -dict $OUTPUT_BASE_NAME.dict
