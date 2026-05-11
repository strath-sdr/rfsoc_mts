# -------------------------------------------------------------------------------------------------
# Copyright (C) 2023 Advanced Micro Devices, Inc
# SPDX-License-Identifier: MIT
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --

# Build MTS necessary patch to xrfdc package
echo "Cloning the PYNQ repository"
git clone --branch image_v3.1.1 https://github.com/Xilinx/PYNQ.git
cd PYNQ

# Apply changes to xrfdc and reinstall the package
git apply ../boards/patches/xrfdc_mts.patch

pushd sdbuild/packages/xrfdc
. pre.sh
. qemu.sh
popd

# Move required LMK/LMX driver files into xrfclk and reinstall the package
sudo cp -r ../rfsoc_mts/rfsoc_mts/xrfclk/* ./sdbuild/packages/xrfclk/package/xrfclk

pushd sdbuild/packages/xrfclk
. pre.sh
. qemu.sh
popd

# Install rfsoc_mts package and notebook
cd ..
python3 -m pip install . --no-build-isolation
pynq-get-notebooks RFSoC-MTS -p $PYNQ_JUPYTER_NOTEBOOKS
echo "$BOARD Ready..."