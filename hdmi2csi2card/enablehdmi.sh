#!/bin/bash
MEDIADEVICE=-1
#SELECT RESOLUTION VALID VALUES (720p60edid, 1080p25edid, 1080p30edid, 1080p50edid, 1080p60edid)
VIDEDID=1080p60edid
# Finding Media Device
i=0
while true ; do
    MEDIADEVICE=$(udevadm info -a -n /dev/media$i | grep --line-buffered 'DRIVERS=="\rp1-cfe"' | while read -r line; do echo $i ; done)
    if ! [[ $MEDIADEVICE = '' ]];  then
        break
    fi
    i=$((i+1))
done


#v4l2-ctl --list-devices
# Locate the node corresponding to tc358743 as v4l-subdev2, and the pad0 of rp1-cfe-csi2_ch0 as video0:
#media-ctl -d /dev/media$MEDIADEVICE -p

# Loading Driver
v4l2-ctl -d /dev/v4l-subdev2 --set-edid=file=$VIDEDID --fix-edid-checksums
# Wait drive loads
sleep 5s

# To query the current input source information, if the resolution displays as 0, it indicates that no input source signal has been detected. In this case, you should check the hardware connections and follow the steps mentioned above to troubleshoot.
v4l2-ctl -d /dev/v4l-subdev2 --query-dv-timings
# Confirm the current input source information.
v4l2-ctl -d /dev/v4l-subdev2 --set-dv-bt-timings query

# Initialize media
media-ctl -d /dev/media$MEDIADEVICE -r
# Connect CSI2's pad4 to rp1-cfe-csi2_ch0's pad0.
media-ctl -d /dev/media$MEDIADEVICE -l  ''\''csi2'\'':4 -> '\''rp1-cfe-csi2_ch0'\'':0 [1]'
# Configure the media node.
media-ctl -d /dev/media$MEDIADEVICE -V ''\''csi2'\'':0 [fmt:RGB888_1X24/1920x1080 field:none colorspace:srgb]'
media-ctl -d /dev/media$MEDIADEVICE -V ''\''csi2'\'':4 [fmt:RGB888_1X24/1920x1080 field:none colorspace:srgb]'
media-ctl -d /dev/media$MEDIADEVICE -V ''\''tc358743 4-000f'\'':0 [fmt:RGB888_1X24/1920x1080 field:none colorspace:srgb]'

#Set the output format.
v4l2-ctl -v width=1920,height=1080,pixelformat=RGB3

# test frames
v4l2-ctl --stream-mmap=3 --stream-count=10 --stream-to=/dev/null
