#!/bin/bash

# Clone the PYNQ 3.1.1 image
git clone --branch image_v3.1.1 https://github.com/Xilinx/PYNQ.git
cd PYNQ

# Apply changes to xrfdc and reinstall the package
echo "Applying xrfdc MTS patch & reinstalling the package"
#git apply ../boards/patches/xrfdc_mts.patch
git apply ../boards/patches/xrfdc_mts2.patch

pushd sdbuild/packages/xrfdc
. pre.sh
. qemu.sh
popd
export BOARD="$(tr -d '\0' < /proc/device-tree/chosen/pynq_board)" # Source the board again

# Move required LMK/LMX driver files into xrfclk and reinstall the package
echo "Copying LMK/LMX files into xrfclk and reinstalling the package"
sudo cp -r ../boards/$BOARD/rfsoc_mts/xrfclk/. ./sdbuild/packages/xrfclk/package/xrfclk/

pushd sdbuild/packages/xrfclk
. pre.sh
. qemu.sh
popd
export BOARD="$(tr -d '\0' < /proc/device-tree/chosen/pynq_board)" # Source the board again

# Install rfsoc_mts package and notebook
echo "Installing rfsoc_mts package"
cd ..
python3 -m pip install . --no-build-isolation

echo "The MTS demonstration is now installed!"