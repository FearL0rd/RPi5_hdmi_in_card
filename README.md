# RPi5_hdmi_in_card
**Raspberry Pi5 HDMI to CSI-2 input card based on TC358743**

**I created this tutorial to help the community enable cheap HDMI to CSI-2 cards like Geekworm C790 based on TC358743**
**The script intends to automatically detect the media device that keeps changing every boot**

## STEPS

### 1- Modify the config file 
        _sudo nano /boot/firmware/config.txt\_

### 2- Add/Modify the entries below

        _dtparam=i2c_arm=on\
        dtparam=i2s=on\
        dtparam=spi=on\
        dtparam=i2c_baudrate=10000\
        dtparam=i2c_vc=on
        
        camera_auto_detect=0
        
        dtoverlay=vc4-kms-v3d,cma-512\
        max_framebuffers=2

        [all]\
        dtoverlay=tc358743,4lane=1\
        dtoverlay=tc358743-audio_

### 3- Copy the hdmi2csi2card with all files to you RPi5

### 4- Run the enablehdmi.sh script with bash
Make sure the device ios connected to the HDMI IN
    
        _bash enablehdmi.sh_

**The script is fully customizable. You can play with the variable and change the detection resolution.**

**Running the Script**
![alt text](https://github.com/FearL0rd/RPi5_hdmi_in_card/blob/main/HDMICARDIMG.png?raw=true)

**Testing with OpenCV**
![alt text](https://github.com/FearL0rd/RPi5_hdmi_in_card/blob/main/HDMICARDIMGOPENCV.png?raw=true)

