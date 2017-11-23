FPGA
====

Digilent ZYBO
-------------

XC7Z010-1CLG400C

* [Zybo](https://reference.digilentinc.com/reference/programmable-logic/zybo/start)
* [Digilent Zybo Zynq-7000 ARM/FPGA SoC Trainer Board](https://www.xilinx.com/products/boards-and-kits/1-4azfte.html)
* [ZYBO FPGA Board Reference Manual](https://reference.digilentinc.com/_media/zybo:zybo_rm.pdf)
* [Schematic](https://reference.digilentinc.com/_media/zybo:zybo_sch.pdf)
* [The Zynq Book](http://www.zynqbook.com/)
* [Zynq-7000 All Programmable SoC Technical Reference Manual](https://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf)
* [Zynq-7000 Datasheet](https://www.xilinx.com/support/documentation/data_sheets/ds187-XC7Z010-XC7Z020-Data-Sheet.pdf)

Nexys 2
-------

XC3S500E: package FG320 (320-ball fine-pitch ball grid array), speed grade 4, temperature range C

* [Nexys 2](https://reference.digilentinc.com/reference/programmable-logic/nexys-2/start)
* [Spartan-3E FPGA Family](https://www.xilinx.com/support/documentation/data_sheets/ds312.pdf)
* [Nexys 2 Reference Manual](https://reference.digilentinc.com/_media/reference/programmable-logic/nexys-2/nexys2_rm.pdf)
* [Master UCF 500](https://reference.digilentinc.com/_media/reference/programmable-logic/nexys-2/nexys2_500general_ucf.zip)
* [Schematic](https://reference.digilentinc.com/_media/reference/programmable-logic/nexys-2/nexys2_sch.pdf)

Digilent Spartan-3E Starter
---------------------------

XC3S500E: package FG320 (320-ball fine-pitch ball grid array), speed grade 4, temperature range C

Using the integrated Xilinx Platform Cable on Ubuntu 14.04 with ISE iMPACT:

```sh
sudo apt-get install fxload
```

Replace the contents of `/etc/udev/rules.d/52-xilinx-pcusb.rules` with (from <https://github.com/timvideos/HDMI2USB/wiki/Xilinx-Platform-Cable-USB-under-Linux>):
```sh
ATTRS{idVendor}=="03fd", ATTRS{idProduct}=="0008", MODE="666"
SUBSYSTEM=="usb", ACTION=="add", ATTRS{idVendor}=="03fd", ATTRS{idProduct}=="0007", RUN+="/sbin/fxload -v -t fx2 -I /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/xusbdfwu.hex -D $tempnode"
SUBSYSTEM=="usb", ACTION=="add", ATTRS{idVendor}=="03fd", ATTRS{idProduct}=="0009", RUN+="/sbin/fxload -v -t fx2 -I /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/xusb_xup.hex -D $tempnode"
SUBSYSTEM=="usb", ACTION=="add", ATTRS{idVendor}=="03fd", ATTRS{idProduct}=="000d", RUN+="/sbin/fxload -v -t fx2 -I /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/xusb_emb.hex -D $tempnode"
SUBSYSTEM=="usb", ACTION=="add", ATTRS{idVendor}=="03fd", ATTRS{idProduct}=="000f", RUN+="/sbin/fxload -v -t fx2 -I /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/xusb_xlp.hex -D $tempnode"
SUBSYSTEM=="usb", ACTION=="add", ATTRS{idVendor}=="03fd", ATTRS{idProduct}=="0013", RUN+="/sbin/fxload -v -t fx2 -I /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/xusb_xp2.hex -D $tempnode"
SUBSYSTEM=="usb", ACTION=="add", ATTRS{idVendor}=="03fd", ATTRS{idProduct}=="0015", RUN+="/sbin/fxload -v -t fx2 -I /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/xusb_xse.hex -D $tempnode"
```

* [Digilent Spartan-3E Starter Board](https://www.xilinx.com/products/boards-and-kits/1-elhacw.html)
* [Spartan-3E Starter Kit Board User Guide](https://reference.digilentinc.com/_media/s3e:s3estarter_ug.pdf)
* [Schematic](https://reference.digilentinc.com/_media/s3e:spartan-3e_sch.pdf)

Misc
----

* [ISE WebPACK Design Software](https://www.xilinx.com/products/design-tools/ise-design-suite/ise-webpack.html)
* [Vivado HL WebPACK](https://www.xilinx.com/products/design-tools/vivado/vivado-webpack.html)
* [ModelSim PE Student Edition](https://www.mentor.com/company/higher_ed/modelsim-student-edition)

Launch ISE Webpack:
```sh
. /opt/Xilinx/14.7/ISE_DS/settings64.sh
ise
```

Launch ISE iMPACT:
```sh
. /opt/Xilinx/14.7/ISE_DS/settings64.sh
impact
```
