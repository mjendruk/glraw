
# GLRAW_DIR
# GLRAW_FOUND
# GLRAW_LIBRARIES
# GLRAW_INCLUDES


# GLRAW_LIBRARY
# GLRAW_LIBRARY_RELEASE
# GLRAW_LIBRARY_DEBUG
# GLRAW_INCLUDE_DIR



# Definition of function "find" with two mandatory arguments, "LIB_NAME" and "HEADER".
function (find LIB_NAME HEADER)

    set(HINT_PATHS ${ARGN})

    if (${LIB_NAME} STREQUAL "glraw")
        set(LIB_NAME_UPPER GLRAW)
        set(LIBNAME glraw)
    else()
        string(TOUPPER GLRAW_${LIB_NAME} LIB_NAME_UPPER)
        set(LIBNAME ${LIB_NAME})
    endif()

    find_path(
	${LIB_NAME_UPPER}_INCLUDE_DIR
	${HEADER}
        ${ENV_GLRAW_DIR}/include
        ${ENV_GLRAW_DIR}/source/${LIB_NAME}/include
        ${GLRAW_DIR}/include
        ${GLRAW_DIR}/source/${LIB_NAME}/include
        ${ENV_PROGRAMFILES}/glraw/include
        /usr/include
        /usr/local/include
        /sw/include
        /opt/local/include
        DOC "The directory where ${HEADER} resides"
    )


    find_library(
	${LIB_NAME_UPPER}_LIBRARY_RELEASE
        NAMES ${LIBNAME}
        PATHS ${HINT_PATHS}
        DOC "The ${LIB_NAME} library"
    )
    find_library(
	${LIB_NAME_UPPER}_LIBRARY_DEBUG
        NAMES ${LIBNAME}d
        PATHS ${HINT_PATHS}
        DOC "The ${LIB_NAME} debug library"
    )
    

    if(${LIB_NAME_UPPER}_LIBRARY_RELEASE AND ${LIB_NAME_UPPER}_LIBRARY_DEBUG)
        set(${LIB_NAME_UPPER}_LIBRARY "optimized" ${${LIB_NAME_UPPER}_LIBRARY_RELEASE} "debug" ${${LIB_NAME_UPPER}_LIBRARY_DEBUG})
    elseif(${LIB_NAME_UPPER}_LIBRARY_RELEASE)
        set(${LIB_NAME_UPPER}_LIBRARY ${${LIB_NAME_UPPER}_LIBRARY_RELEASE})
    elseif(${LIB_NAME_UPPER}_LIBRARY_DEBUG)
        set(${LIB_NAME_UPPER}_LIBRARY ${${LIB_NAME_UPPER}_LIBRARY_DEBUG})
    endif()


    set(GLRAW_INCLUDES  ${GLRAW_INCLUDES}  ${${LIB_NAME_UPPER}_INCLUDE_DIR} PARENT_SCOPE)
    set(GLRAW_LIBRARIES ${GLRAW_LIBRARIES} ${${LIB_NAME_UPPER}_LIBRARY} PARENT_SCOPE)

    # DEBUG MESSAGES
#    message("${LIB_NAME_UPPER}_INCLUDE_DIR     = ${${LIB_NAME_UPPER}_INCLUDE_DIR}")
#    message("${LIB_NAME_UPPER}_LIBRARY_RELEASE = ${${LIB_NAME_UPPER}_LIBRARY_RELEASE}")
#    message("${LIB_NAME_UPPER}_LIBRARY_DEBUG   = ${${LIB_NAME_UPPER}_LIBRARY_DEBUG}")
#    message("${LIB_NAME_UPPER}_LIBRARY         = ${${LIB_NAME_UPPER}_LIBRARY}")

endfunction(find)








# load standard CMake arguments (c.f. http://stackoverflow.com/questions/7005782/cmake-include-findpackagehandlestandardargs-cmake)
include(FindPackageHandleStandardArgs)

if(CMAKE_CURRENT_LIST_FILE)
    get_filename_component(GLRAW_DIR ${CMAKE_CURRENT_LIST_FILE} PATH)
endif()

file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" ENV_PROGRAMFILES)
file(TO_CMAKE_PATH "$ENV{GLRAW_DIR}" ENV_GLRAW_DIR)

set(LIB_PATHS   
    ${GLRAW_DIR}/build
    ${GLRAW_DIR}/build/Release
    ${GLRAW_DIR}/build/Debug
    ${GLRAW_DIR}/build-release
    ${GLRAW_DIR}/build-debug
    ${GLRAW_DIR}/lib
    ${ENV_GLRAW_DIR}/lib
    ${ENV_PROGRAMFILES}/glraw/lib
    /usr/lib
    /usr/local/lib
    /sw/lib
    /opt/local/lib
    /usr/lib64
    /usr/local/lib64
    /sw/lib64
    /opt/local/lib64
)


# Find libraries
find(glraw glraw/glraw_api.h ${LIB_PATHS})


# DEBUG
#message("GLRAW_INCLUDES  = ${GLRAW_INCLUDES}")
#message("GLRAW_LIBRARIES = ${GLRAW_LIBRARIES}")

find_package_handle_standard_args(GLRAW DEFAULT_MSG GLRAW_LIBRARIES GLRAW_INCLUDES)
mark_as_advanced(GLRAW_FOUND)