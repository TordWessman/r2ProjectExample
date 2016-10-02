
#gst-launch-1.0 -v filesrc location="test.flac" ! flacdec ! alsasink ! audioconvert 00000000.raw
gst-launch-1.0 -v filesrc location=$1 !  audio/x-raw,format=\(string\)S16LE,layout=\(string\)interleaved,rate=\(int\)8000,channels=1 ! flacenc ! filesink location=$2 > /dev/null
