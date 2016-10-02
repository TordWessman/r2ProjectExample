#!/bin/bash
# Example of raspberry pi video streaming using internal pi-camera.
# the force-ipv4=true is due to the fact that gstmultiudpsink opens an IPv6 socket, and then does a sendmsg() to an IPv4 address.
# see http://lists.freedesktop.org/archives/gstreamer-bugs/2013-March/100411.html
raspivid -t 999999 -n -w $1 -h $2 -rot $8 \
-fps $3 -b $4 -o - \
| gst-launch-1.0 -vvvv fdsrc ! h264parse ! rtph264pay config-interval=5 pt=96 ! tee ! queue ! udpsink host=$5 port=$6 force-ipv4=true tee0. ! queue ! udpsink host=$7 port=$6 force-ipv4=true #> /dev/null


## to/from pi:
#  raspivid -t 0 -h 240 -w 320 -fps 30 -vf -hf -b 16536 -o - | gst-launch-1.0 -v fdsrc ! h264parse !  mpegtsmux ! tcpserversink port=8554 host=192.168.0.190
# gst-launch-1.0 tcpclientsrc port=8554 host=192.168.0.190  ! tsdemux ! h264parse ! avdec_h264 ! xvimagesink 

#  raspivid -t 0 -h 240 -w 320 -fps 30 -vf -hf -b 16536 -o - | gst-launch-1.0 -v fdsrc ! h264parse ! rtph264pay config-interval=1  ! gdppay ! queue leaky=1 max-size-buffers=4 ! tcpserversink port=8554 host=192.168.0.190
 # gst-launch-1.0 -v tcpclientsrc port=8554 host=192.168.0.190 ! gdpdepay  ! application/x-rtp, payload=96 ! rtph264depay !  queue leaky=1 max-size-buffers=16 ! avdec_h264 ! xvimagesink 

