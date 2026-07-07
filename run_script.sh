set -e

REBUILD=""
DONT_BUILD=""
WITH_ASAN=""
BUILD_ARGS=""
BUILD_DIR=""
RJ_DIR="../yggdrasil_rapidjson"
if [ ! -d ${RJ_DIR} ]; then
    RJ_DIR="$(pwd)/yggdrasil-rapidjson"
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        --rebuild )
            REBUILD="TRUE"
            shift
            ;;
        --dont-use-local )
            RJ_DIR=""
	    shift # past argument with no value
	    ;;
	--dont-build )
	    DONT_BUILD="TRUE"
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
    esac
done

if [ -n "$WITH_ASAN" ]; then
    export ASAN_OPTIONS=symbolize=1
    export ASAN_SYMBOLIZER_PATH=$(which llvm-symbolizer)
    BUILD_ARGS="${BUILD_ARGS} --config-settings=cmake.define.YGGDRASIL_RAPIDJSON_BUILD_ASAN:BOOL=ON --config-settings=cmake.define.YGGDRASIL_RAPIDJSON_BUILD_UBSAN:BOOL=ON"
fi
if [ -n "$BUILD_DIR" ]; then
    BUILD_ARGS="${BUILD_ARGS} --config-settings=build-dir=${BUILD_DIR}"
fi
if [ ! -n "$DONT_BUILD" ]; then
    if [ -n "$RJ_DIR" ]; then
        RJ_INSTALL_DIR="$RJ_DIR/_install_for_pyrj"
        RJ_BUILD_DIR="$RJ_DIR/_build_for_pyrj"
        if [ -n "$REBUILD" ]; then
            if [ -d "$RJ_INSTALL_DIR" ]; then
                rm -rf "$RJ_INSTALL_DIR"
            fi
            if [ -d "$RJ_BUILD_DIR" ]; then
                rm -rf "$RJ_BUILD_DIR"
            fi
        fi
        ./install_local_rapidjson.sh --rj-dir $RJ_DIR --install-dir $RJ_INSTALL_DIR --build-dir $RJ_BUILD_DIR
        pip install \
            --config-settings=cmake.define.CMAKE_PREFIX_PATH=$RJ_INSTALL_DIR \
	    $BUILD_ARGS -v -e .
    else
        pip install $BUILD_ARGS -v -e .
    fi
fi

if [ -n "$WITH_ASAN" ]; then
    export DYLD_INSERT_LIBRARIES=$(clang -print-file-name=libclang_rt.asan_osx_dynamic.dylib)
fi

python -m pytest -sv tests/ --doctest-glob="docs/*.rst" --doctest-modules docs
# make -C docs doctest -e PYTHON=$(python -c "import sys; import pathlib; print(pathlib.Path(sys.executable).resolve(strict=True))") -e DYLD_INSERT_LIBRARIES=$(clang -print-file-name=libclang_rt.asan_osx_dynamic.dylib)
