#!/usr/bin/env bash
echo "checking out OpenBLAS..."
git clone https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS


echo "compiling..."
make

echo "installing on /opt/OpenBLAS"
sudo make PREFIX=/opt/OpenBLAS install

echo "copying libraries"
sudo cp /opt/OpenBLAS/lib/libopenblas.so /opt/OpenBLAS/lib/liblapack.so.3
sudo cp /opt/OpenBLAS/lib/libopenblas.so /opt/OpenBLAS/lib/libblas.so.3

echo "successfully installed OpenBLAS"