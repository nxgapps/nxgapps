#This file is part of The NX GApps Project script of @AlexLartsev19.
#
#    The NX GApps Project scripts are free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    These scripts are distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
# build paths
TOPDIR := .
BUILD_SYSTEM := $(TOPDIR)/scripts
BUILD_GAPPS := $(BUILD_SYSTEM)/build_gapps.sh
OUTDIR := $(TOPDIR)/out
LOG_BUILD := /tmp/gapps_log

clean :
	@rm -fr $(OUTDIR)
	@echo "$(tput setaf 2)Output removed! Ready for a clean build$(tput sgr 0)"

arm :
	@echo "Compiling NX GApps package for arm devices..."
	@bash $(BUILD_GAPPS) arm 2>&1

arm64 :
	@echo "Compiling NX GApps package for arm64 devices..."
	@bash $(BUILD_GAPPS) arm64 2>&1

x86 :
	@echo "Compiling NX GApps package for x86 devices..."
	@bash $(BUILD_GAPPS) x86 2>&1

x86_64 :
	@echo "Compiling NX GApps package for x86_64 devices..."
	@bash $(BUILD_GAPPS) x86_64 2>&1