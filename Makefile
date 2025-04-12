.PHONY: main clean

main: build
	rm -rf build/CompilationDatabase
	xcrun xcodebuild -configuration Debug OTHER_CFLAGS="\$(inherited)-gen-cdb-fragment-path build/CompilationDatabase"
	./tools/merge_compilation_commands.py --fragments-dir build/CompilationDatabase --out-path build

build:
	mkdir -p build

clean:
	rm -rf build
