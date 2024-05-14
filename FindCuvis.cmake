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


if(NOT Cuvis_LIBRARY)
	message(FATAL_ERROR "Could not locate cuvis library")
else()
  if(NOT TARGET cuvis::c)
	  add_library(cuvis::c STATIC IMPORTED)
	  set_target_properties(
		cuvis::c
		PROPERTIES
		  INTERFACE_INCLUDE_DIRECTORIES "${Cuvis_INCLUDE_DIR}"
		  IMPORTED_LOCATION ${Cuvis_LIBRARY})
	  
	  find_package(Doxygen)
	  option(DOXYGEN_BUILD_DOCUMENTATION "Create and install the HTML based API documentation (requires Doxygen)" TRUE)
			
	  if(DOXYGEN_BUILD_DOCUMENTATION)
		  if(NOT DOXYGEN_FOUND)
			 message(status "Doxygen is needed to build the documentation.")
	      else()
			  if(NOT TARGET cuvis_c_doxygen)
			  
				  file(MAKE_DIRECTORY  ${CMAKE_BINARY_DIR}/doc )
					
					set(MAINPAGE ${CMAKE_CURRENT_LIST_DIR}/doc/mainpage.h)
					set(DOXYGEN_IN ${CMAKE_CURRENT_LIST_DIR}/doxygen/doxyfile_iface.in)
					set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/doxyfile_iface)

					# request to configure the file
					configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)	
					
					add_custom_target(cuvis_c_doxygen 
					COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/doxyfile_iface
									  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
									  COMMENT "Generating API documentation with Doxygen (iface)"
									  VERBATIM
					)
					
					
			  
				endif()
		  endif()
		  
		  
		add_dependencies(cuvis::c cuvis_c_doxygen)
	 
		endif()

	  
  endif()
  
  # Function to extract version from DLL
  function(get_library_version LIB_PATH OUTPUT_VARIABLE)
    set(GET_VERSION_SOURCE "${CMAKE_CURRENT_LIST_DIR}/helper/get_version.c")

	try_run(
		GET_VERSION_RUN_RESULT GET_VERSION_COMPILE_RESULT
        ${CMAKE_BINARY_DIR}/try_compile
        SOURCES ${GET_VERSION_SOURCE}
		RUN_OUTPUT_VARIABLE  ${OUTPUT_VARIABLE}
		LINK_LIBRARIES cuvis::c
		COMPILE_OUTPUT_VARIABLE GET_VERSION_COMPILE_INFO
        CMAKE_FLAGS
            -DINCLUDE_DIRECTORIES=${Cuivs_INCLUDE_DIR}
            -DLINK_LIBRARIES=${Cuvis_LIBRARY}
		)
		if (NOT GET_VERSION_COMPILE_RESULT)
			message("Failed to compile and run get_version_executable")
			message(FATAL_ERROR "${GET_VERSION_COMPILE_INFO}")
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
		VERSION_VAR Cuvis_VERSION
		HANDLE_VERSION_RANGE)
		 



endif()