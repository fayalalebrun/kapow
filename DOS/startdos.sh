#!/bin/bash

dosbox -fullscreen -c "MOUNT C: ../assets" -c "C:" -c "IMGMOUNT E dpe.img -t floppy" -c "E:" -c "dp"
