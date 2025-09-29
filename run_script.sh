set -e

DONT_BUILD=""
DONT_TEST=""
WITH_ASAN=""
BUILD_ARGS=""
BUILD_DIR=""
BUILD_DOCS=""

while [[ $# -gt 0 ]]; do
    case $1 in
	--dont-build )
	    DONT_BUILD="TRUE"
	    shift # past argument with no value
	    ;;
	--dont-test )
	    DONT_TEST="TRUE"
	    shift # past argument with no value
	    ;;
	--with-asan )
	    WITH_ASAN="TRUE"
	    shift # past argument with no value
	    ;;
        --build-dir )
            BUILD_DIR="$2"
	    shift
	    shift # past argument with value
	    ;;
        --build-docs )
            BUILD_DOCS="TRUE"
            DONT_BUILD="TRUE"
            DONT_TEST="TRUE"
            shift # past argument with no value
            ;;
    esac
done

if [ -n "$BUILD_DOCS" ]; then
    if [ ! -n "$BUILD_DIR" ]; then
        BUILD_DIR="build_docs"
    fi
    rm -rf $BUILD_DIR
    mkdir $BUILD_DIR
    cd $BUILD_DIR
    cmake .. -DPYRJ_BUILD_DOCS_FOR_PUBLISH=ON
    cmake --build .
    cd ..
fi

if [ -n "$WITH_ASAN" ]; then
    export ASAN_OPTIONS=symbolize=1
    export ASAN_SYMBOLIZER_PATH=$(which llvm-symbolizer)
    BUILD_ARGS="${BUILD_ARGS} --config-settings=cmake.define.YGG_BUILD_ASAN:BOOL=ON --config-settings=cmake.define.YGG_BUILD_UBSAN:BOOL=ON"
fi
if [ -n "$BUILD_DIR" ]; then
    BUILD_ARGS="${BUILD_ARGS} --config-settings=build-dir=${BUILD_DIR}"
fi
if [ ! -n "$DONT_BUILD" ]; then
    pip install --config-settings=cmake.define.RAPIDJSON_INCLUDE_DIRS=../rapidjson/include/ \
	$BUILD_ARGS -v -e .
fi

if [ -n "$WITH_ASAN" ]; then
    export DYLD_INSERT_LIBRARIES=$(clang -print-file-name=libclang_rt.asan_osx_dynamic.dylib)
fi

if [ ! -n "$DONT_TEST" ]; then
    python -m pytest -sv tests/ --doctest-glob="docs/*.rst" --doctest-modules docs
    # make -C docs doctest -e PYTHON=$(python -c "import sys; import pathlib; print(pathlib.Path(sys.executable).resolve(strict=True))") -e DYLD_INSERT_LIBRARIES=$(clang -print-file-name=libclang_rt.asan_osx_dynamic.dylib)
fi
