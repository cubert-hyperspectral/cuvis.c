cmake_minimum_required(VERSION 3.25.0)
include(GNUInstallDirs)

find_library(
	Cuvis_LIBRARY
    NAMES "cuvis"
    HINTS "/lib/cuvis" "$ENV{PROGRAMFILES}/Cuvis/bin")

find_path(Cuvis_INCLUDE_DIR
	NAMES cuvis.h
	HINTS "/usr/include/" "$ENV{PROGRAMFILES}/Cuvis/sdk/cuvis_c")

include(FindPackageHandleStandardArgs)

mark_as_advanced(Cuvis_LIBRARY Cuvis_INCLUDE_DIR)

if(Cuvis_FOUND AND NOT TARGET cuvis::c)
  add_library(cuvis::c STATIC IMPORTED)
  set_target_properties(
    cuvis::c
    PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${Cuvis_INCLUDE_DIR}"
      IMPORTED_LOCATION ${Cuvis_LIBRARY})

  # Function to extract version from DLL
  function(get_library_version LIB_PATH OUTPUT_VARIABLE)
    set(GET_VERSION_SOURCE "${CMAKE_CURRENT_LIST_DIR}/helper/get_version.c")

	try_run(
		GET_VERSION_RUN_RESULT GET_VERSION_COMPILE_RESULT
        ${CMAKE_BINARY_DIR}/try_compile
        SOURCES ${GET_VERSION_SOURCE}
		RUN_OUTPUT_VARIABLE  ${OUTPUT_VARIABLE}
		LINK_LIBRARIES cuvis::c
        CMAKE_FLAGS
            -DINCLUDE_DIRECTORIES=${Cuivs_INCLUDE_DIR}
            -DLINK_LIBRARIES=${Cuvis_LIBRARY}
		)
		if (NOT GET_VERSION_COMPILE_RESULT)
			message(FATAL_ERROR "Failed to compile and run get_version_executable")
		endif()
		set(${OUTPUT_VARIABLE} "${${OUTPUT_VARIABLE}}" CACHE INTERNAL "${OUTPUT_VARIABLE}")
  endfunction()

  # Get the version of the library
  get_library_version("${Cuvis_LIBRARY}" LIB_VERSION)

  # Parse the version components
  string(REGEX MATCH "v\\. ([0-9]+)\\.([0-9]+)\\.([0-9]+)" LIB_VERSION_MATCH "${LIB_VERSION}")
  # Check if the version was successfully extracted
  if (NOT LIB_VERSION_MATCH)
      message(FATAL_ERROR "Failed to extract version from the library")
  endif()

  set(lib_version_MAJOR ${CMAKE_MATCH_1})
  set(lib_version_MINOR ${CMAKE_MATCH_2})
  set(lib_version_PATCH ${CMAKE_MATCH_3})

  # Check the library version against the required version
  set(CUVIS_VERSION_STRING "${lib_version_MAJOR}.${lib_version_MINOR}.${lib_version_PATCH}")

  # Provide configuration information for find_package(Cuvis)

  set(Cuvis_FOUND TRUE CACHE INTERNAL "")
  set(Cuvis_VERSION "${lib_version_MAJOR}.${lib_version_MINOR}.${lib_version_PATCH}" CACHE INTERNAL "")
  set(Cuvis_INCLUDE_DIRS "${Cuvis_INCLUDE_DIR}" CACHE INTERNAL "")
  set(Cuvis_LIBRARIES "cuvis::c" CACHE INTERNAL "")
  
  find_package_handle_standard_args(Cuvis
	REQUIRED_VARS Cuvis_LIBRARY Cuvis_INCLUDE_DIR
	VERSION_VAR Cuvis_VERSION)
  
endif()