cmake_path(GET ${PYTHON_PREFIX}_EXECUTABLE PARENT_PATH Python_BIN_DIR)
cmake_path(APPEND Python_BIN_DIR sphinx-build OUTPUT_VARIABLE SPHINX_BUILD)

IF(NOT EXISTS ${SPHINX_BUILD})
    MESSAGE(STATUS "sphinx-build not at expected location (${SPHINX_BUILD}). Documentation won't be built")
ELSE()
    file(GLOB SOURCES ${CMAKE_CURRENT_LIST_DIR}/../*.cpp)
    file(GLOB RST_DOC ${CMAKE_CURRENT_LIST_DIR}/../docs/*.rst)
    list(APPEND RST_DOC ${CMAKE_CURRENT_LIST_DIR}/../README.rst)

    set(GIT_COMMANDS)
    if(PYRJ_BUILD_DOCS_FOR_PUBLISH)
        set(
            GIT_COMMANDS
            COMMAND git fetch origin gh-pages
            COMMAND git worktree add -f ${CMAKE_CURRENT_BINARY_DIR}/html gh-pages
        )
    endif()

    add_custom_command(OUTPUT html
        ${GIT_COMMANDS}
        COMMAND ${${PYTHON_PREFIX}_EXECUTABLE} -m sphinx ${CMAKE_CURRENT_LIST_DIR} ${CMAKE_CURRENT_BINARY_DIR}/html
        COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_BINARY_DIR}/html
        DEPENDS ${RST_DOC} ${SOURCES}
        # WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/../
    )

    add_custom_target(docs ALL DEPENDS html)
    # install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html
    #     DESTINATION ${DOC_INSTALL_DIR}
    #     COMPONENT docs
    # )
ENDIF()
