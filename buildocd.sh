#! /bin/bash
#
# Script to build openocd
# Tools will be installed to $RISCV.
set -x

if [ "x$RISCV" = "x" ]
then
  echo "Please set the RISCV environment variable to your preferred install path."
  exit 1
fi

# Use gmake instead of make if it exists.
MAKE=`command -v gmake || command -v make`

PATH="$RISCV/bin:$PATH"
#GCC_VERSION=`gcc -v 2>&1 | tail -1 | awk '{print $3}'`

set -e

  PROJECT="riscv-openocd"
  echo
  if [ -e "$PROJECT/build" ]
  then
    echo "Removing existing $PROJECT/build directory"
    rm -rf "$PROJECT/build"
  fi
  if [ ! -e "$PROJECT/configure" ]
  then
    (
      cd "$PROJECT"
      find . -iname configure.ac | sed s/configure.ac/m4/ | xargs mkdir -p
      autoreconf -i
    )
  fi
  mkdir -p "$PROJECT/build"
  cd "$PROJECT/build"
  echo "Configuring project $PROJECT"
  ../configure --prefix=$RISCV --enable-remote-bitbang --enable-jtag_vpi --disable-werror > build.log
  echo "Building project $PROJECT"
  $MAKE >> build.log
  echo "Installing project $PROJECT"
  $MAKE install >> build.log
  cd - > /dev/null
