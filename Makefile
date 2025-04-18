.PHONY: build clean sync

build: build/build.ninja
	cmake --build build
	./build/src/metal_sandbox

build/build.ninja:
	mkdir -p build
	cmake -G Ninja -B build

clean:
	rm -rf build

sync:
	git submodule update --init --recursive -j 8
