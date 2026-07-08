cmake_minimum_required(VERSION 3.15)
if(NOT SKBUILD)
  message(FATAL_ERROR "Must be built via scikit-build-core")
endif()

# compile in release with debug info mode by default
if(NOT CMAKE_BUILD_TYPE)
  # This must be before the project call or the default Debug value used
  # by the Ninja generator will be used
  # https://discourse.cmake.org/t/how-to-deal-with-ninja-setting-cmake-build-type-to-debug/281
  set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif()

PROJECT(${SKBUILD_PROJECT_NAME} VERSION "${SKBUILD_PROJECT_VERSION}")
message(STATUS "SKBUILD_PROJECT_VERSION = ${SKBUILD_PROJECT_VERSION}")

set(PYRJ_ALTERNATE_MODULE "yggdrasil_rapidjson" CACHE STRING "Name of the Python module that should be built")

set(CMAKE_VERBOSE_MAKEFILE ON)

if (WIN32)
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()
if (APPLE AND "$ENV{SDKROOT}")
  SET(CMAKE_OSX_SYSROOT "$ENV{SDKROOT}")
endif()
message(STATUS "CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")

if (WIN32)
   set(CMAKE_CXX_EXTENSIONS OFF)
endif()
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(YGGDRASIL_RAPIDJSON_PYTHON_WRAPPER ON)

find_package(
  Python3 COMPONENTS
  Interpreter Development.Module NumPy REQUIRED
)
if (Python3_VERSION VERSION_LESS "3.9.0")
  message(FATAL_ERROR "Only Python 3.9+ is supported.")
endif()

find_package(YggdrasilRapidJSON)
if(NOT YggdrasilRapidJSON_FOUND)
  message(WARNING "Could not locate the YggdrasilRapidJSON package via find_package, installing as an external project...")
  # set(YGGDRASIL_DISABLE_PYTHON_C_API_PREV "${YGGDRASIL_DISABLE_PYTHON_C_API}")
  # set(YGGDRASIL_DISABLE_PYTHON_C_API ON)
  foreach(suffix BUILD_EXAMPLES BUILD_TESTS BUILD_DOC)
    if(NOT YGGDRASIL_RAPIDJSON_${suffix})
      set(YGGDRASIL_RAPIDJSON_${suffix} OFF)
    endif()
  endforeach()
  include(FetchContent)
  FetchContent_Declare(
    YggdrasilRapidJSON
    GIT_REPOSITORY https://github.com/cropsinsilico/yggdrasil-rapidjson.git
    # GIT_TAG          v1.1.0.3
    # GIT_TAG        origin/yggdrasil
    GIT_TAG        origin/bug_fixes  # TODO: Revert this before release
    OVERRIDE_FIND_PACKAGE
  )
  find_package(YggdrasilRapidJSON)
  # FetchContent_MakeAvailable(YggdrasilRapidJSON)
  # set(YGGDRASIL_DISABLE_PYTHON_C_API "${YGGDRASIL_DISABLE_PYTHON_C_API_PREV}")
  # include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/YggdrasilRapidJSONMacros.cmake)
  include(${yggdrasilrapidjson_SOURCE_DIR}/YggdrasilRapidJSONMacros.cmake)
endif()
yggdrasil_rapidjson_global_compiler_flags(CXX)

set(PYRJ_TARGET "yggdrasil_python_rapidjson")
set(PYRJ_SRC "${CMAKE_CURRENT_SOURCE_DIR}/yggdrasil_rapidjson.cpp")

if (PYRJ_ALTERNATE_MODULE)
  if (NOT PYRJ_LIBNAME)
    string(FIND ${PYRJ_ALTERNATE_MODULE} "." IDX_LIBNAME REVERSE)
    message(DEBUG "IDX_LIBNAME = ${IDX_LIBNAME}")
    if(IDX_LIBNAME EQUAL -1)
      set(PYRJ_LIBNAME "${PYRJ_ALTERNATE_MODULE}")
    else()
      MATH(EXPR IDX_LIBNAME "${IDX_LIBNAME}+1")
      string(
        SUBSTRING ${PYRJ_ALTERNATE_MODULE} ${IDX_LIBNAME} -1 PYRJ_LIBNAME
      )
    endif()
  endif()
  if((PYRJ_ALTERNATE_MODULE STREQUAL "yggdrasil_rapidjson") AND
     (PYRJ_LIBNAME STREQUAL "yggdrasil_rapidjson"))
    set(ALT_PYRJ_CPP)
  else()
    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/replace_module.cmake"
    [=[
    file(READ "${SOURCE}" TEXT)
    string(REPLACE "\"yggdrasil_rapidjson\"" "\"${PYRJ_ALTERNATE_MODULE}\"" TEXT "${TEXT}")
    string(REPLACE "\"yggdrasil_rapidjson." "\"${PYRJ_ALTERNATE_MODULE}." TEXT "${TEXT}")
    string(REPLACE ":yggdrasil_rapidjson." ":${PYRJ_ALTERNATE_MODULE}." TEXT "${TEXT}")
    string(REPLACE "PyInit_yggdrasil_rapidjson" "PyInit_${PYRJ_LIBNAME}" TEXT "${TEXT}")
    file(WRITE "${TARGET}" "${TEXT}")
    ]=])

    file(GLOB PYRJ_CPP LIST_DIRECTORIES false
         "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")
    message(DEBUG "PYRJ_CPP = ${PYRJ_CPP}")
    foreach(src IN LISTS PYRJ_CPP)
      set(base)
      cmake_path(GET src FILENAME base)
      cmake_path(APPEND CMAKE_CURRENT_BINARY_DIR ${base}
                 OUTPUT_VARIABLE dst)
      message(DEBUG "Vendoring ${base} from ${src} to ${dst}")
      list(APPEND ALT_PYRJ_CPP ${dst})
      add_custom_command(
        OUTPUT "${dst}"
        COMMAND "${CMAKE_COMMAND}"
                "-DSOURCE=${src}"
	        "-DTARGET=${dst}"
	        "-DPYRJ_ALTERNATE_MODULE=${PYRJ_ALTERNATE_MODULE}"
                "-DPYRJ_LIBNAME=${PYRJ_LIBNAME}"
	        -P "${CMAKE_CURRENT_BINARY_DIR}/replace_module.cmake"
	        DEPENDS "${src}" "${CMAKE_CURRENT_BINARY_DIR}/replace_module.cmake")
    endforeach()
    set(PYRJ_SRC "${CMAKE_CURRENT_BINARY_DIR}/yggdrasil_rapidjson.cpp")
    add_custom_target(alt_rapidjson DEPENDS ${ALT_PYRJ_CPP})
  endif()
endif()

if (NOT PYRJ_LIBNAME)
  set(PYRJ_LIBNAME "yggdrasil_rapidjson")
endif()

message(DEBUG "PYRJ_ALTERNATE_MODULE = ${PYRJ_ALTERNATE_MODULE}")
message(DEBUG "PYRJ_LIBNAME = ${PYRJ_LIBNAME}")
message(DEBUG "PYRJ_TARGET = ${PYRJ_TARGET}")

Python3_add_library(${PYRJ_TARGET} MODULE ${PYRJ_SRC})
set_target_properties(
  ${PYRJ_TARGET} PROPERTIES OUTPUT_NAME ${PYRJ_LIBNAME}
)

if (PYRJ_ALTERNATE_MODULE AND ALT_PYRJ_CPP)
  add_dependencies(${PYRJ_TARGET} alt_rapidjson)
  target_include_directories(
    ${PYRJ_TARGET} PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
  )
endif()

target_link_libraries(
  ${PYRJ_TARGET} PUBLIC YggdrasilRapidJSON Python3::NumPy
)

target_compile_options(
  ${PYRJ_TARGET} PUBLIC
  -DYGGDRASIL_RAPIDJSON_PYTHON_VERSION=${CMAKE_PROJECT_VERSION}
)
if (YGGDRASIL_RAPIDJSON_EXACT_VERSION)
  target_compile_options(
    ${PYRJ_TARGET} PUBLIC
    "-DYGGDRASIL_RAPIDJSON_EXACT_VERSION=${YGGDRASIL_RAPIDJSON_EXACT_VERSION}")
endif()

if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  # Avoid warning about invalid flag for C++
  string(REPLACE "-Wstrict-prototypes" ""
         CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  string(REPLACE "-Wstrict-prototypes" ""
         CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")

  # Ignore warnings about missing members in PyTypeObject objects
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-missing-field-initializers")

  # Add -pedantic, so we get a warning when using non-standard features, and
  # -Wno-long-long to pacify old gcc (or Apple's hybrids) that treat
  # "long long" as an error under C++ (see issue #69). C++11 is required
  # since commit
  # https://github.com/Tencent/rapidjson/commit/9965ab37f6cfae3d58a0a6e34c76112866ace0b1
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pedantic -Wno-long-long") # -std=c++11
  # Up to Python 3.7, some structures use "char*" instead of "const char*",
  # and ISO C++ forbids assigning string literal constants
  if (Python3_VERSION VERSION_LESS "3.7.0")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-write-strings")
  endif()
endif()

# Exact version file
cmake_path(APPEND ${CMAKE_CURRENT_SOURCE_DIR} yggdrasil_rapidjson_exact_version.txt
           OUTPUT_VARIABLE YGGDRASIL_RAPIDJSON_EXACT_VERSION_FILE)
if (EXISTS YGGDRASIL_RAPIDJSON_EXACT_VERSION_FILE)
  file(READ ${YGGDRASIL_RAPIDJSON_EXACT_VERSION_FILE} YGGDRASIL_RAPIDJSON_EXACT_VERSION)
  string(STRIP ${YGGDRASIL_RAPIDJSON_EXACT_VERSION} YGGDRASIL_RAPIDJSON_EXACT_VERSION)
  target_compile_options(
    ${PYRJ_TARGET} PUBLIC
    "-DYGGDRASIL_RAPIDJSON_EXACT_VERSION=${YGGDRASIL_RAPIDJSON_EXACT_VERSION}")
endif()

if (NOT Python3_INSTALL_DIR)
  set(Python3_INSTALL_DIR ".")
endif()

install(TARGETS ${PYRJ_TARGET}
        LIBRARY DESTINATION ${Python3_INSTALL_DIR}
        RUNTIME DESTINATION ${Python3_INSTALL_DIR})
