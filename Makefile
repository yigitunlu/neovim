-include local.mk

CMAKE_FLAGS := -DCMAKE_BUILD_TYPE=Debug -DCMAKE_PREFIX_PATH=.deps/usr -DLibUV_USE_STATIC=YES

# Extra CMake flags which extend the default set
CMAKE_EXTRA_FLAGS :=

build/bin/nvim: deps
	${MAKE} -C build

test: build/bin/nvim
	cd src/testdir && make

deps: .deps/usr/lib/libuv.a

.deps/usr/lib/libuv.a:
	sh -e scripts/compile-libuv.sh

cmake: clean deps
	mkdir build
	cd build && cmake $(CMAKE_FLAGS) $(CMAKE_EXTRA_FLAGS) ../

clean:
	rm -rf build
	for file in lua mbyte mzscheme small tiny; do \
		rm -f src/testdir/$$file.vim; \
	done

install: build/bin/nvim
	${MAKE} -C build install

.PHONY: test deps cmake install

.DEFAULT: build/bin/nvim
