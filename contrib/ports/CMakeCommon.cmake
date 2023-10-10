if(NOT ${CMAKE_VERSION} VERSION_LESS "3.10.0")
    include_guard(GLOBAL)
endif()

if(NOT CMAKE_BUILD_TYPE)
    message(STATUS  "CMAKE_BUILD_TYPE not set - defaulting to Debug build.")
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build, options are: ${CMAKE_CONFIGURATION_TYPES}." FORCE)
endif()
message (STATUS "Build type: ${CMAKE_BUILD_TYPE}")

set(LWIP_CONTRIB_DIR ${LWIP_DIR}/contrib)

set(LWIP_COMPILER_FLAGS_GNU_CLANG
    $<$<CONFIG:Debug>:-Og>
    $<$<CONFIG:Debug>:-g>
    $<$<CONFIG:Release>:-O3>
    -Wall
    -pedantic
    -Werror
    -Wparentheses
    -Wsequence-point
    -Wswitch-default
    -Wextra
    -Wundef
    -Wshadow
    -Wpointer-arith
    -Wcast-qual
    -Wwrite-strings
     $<$<COMPILE_LANGUAGE:C>:-Wold-style-definition>
    -Wcast-align
     $<$<COMPILE_LANGUAGE:C>:-Wmissing-prototypes>
     $<$<COMPILE_LANGUAGE:C>:-Wnested-externs>
    -Wunreachable-code
    -Wuninitialized
    -Wmissing-prototypes
    -Waggregate-return
    -Wlogical-not-parentheses
)

if (NOT LWIP_HAVE_MBEDTLS)
    list(APPEND LWIP_COMPILER_FLAGS_GNU_CLANG
        -Wredundant-decls
        $<$<COMPILE_LANGUAGE:C>:-Wc++-compat>
    )
endif()

if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    list(APPEND LWIP_COMPILER_FLAGS_GNU_CLANG
        -Wlogical-op
        -Wtrampolines
    )

    if (NOT LWIP_HAVE_MBEDTLS)
        list(APPEND LWIP_COMPILER_FLAGS_GNU_CLANG
            $<$<COMPILE_LANGUAGE:C>:-Wc90-c99-compat>
        )
    endif()

    if(NOT CMAKE_C_COMPILER_VERSION VERSION_LESS 4.9)
        if(LWIP_USE_SANITIZERS)
            list(APPEND LWIP_COMPILER_FLAGS_GNU_CLANG
                -fsanitize=address
                -fsanitize=undefined
                -fno-sanitize=alignment
                -fstack-protector
                -fstack-check
            )
            set(LWIP_SANITIZER_LIBS asan ubsan)
        endif()
    endif()

    set(LWIP_COMPILER_FLAGS ${LWIP_COMPILER_FLAGS_GNU_CLANG})
endif()

if(CMAKE_C_COMPILER_ID STREQUAL "Clang")
    list(APPEND LWIP_COMPILER_FLAGS_GNU_CLANG
        -Wdocumentation
        -Wno-documentation-deprecated-sync
    )

    if(LWIP_USE_SANITIZERS)
        list(APPEND LWIP_COMPILER_FLAGS_GNU_CLANG
            -fsanitize=address
            -fsanitize=undefined
            -fno-sanitize=alignment
        )
        set(LWIP_SANITIZER_LIBS asan ubsan)
    endif()

    set(LWIP_COMPILER_FLAGS ${LWIP_COMPILER_FLAGS_GNU_CLANG})
endif()

if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    set(LWIP_COMPILER_FLAGS
        $<$<CONFIG:Debug>:/Od>
        $<$<CONFIG:Release>:/Ox>
        /W4
        /WX
    )
endif()
