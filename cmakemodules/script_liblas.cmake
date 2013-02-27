# Check for the LAS (LiDAR format) library
# ===================================================
IF(UNIX)
	FIND_FILE(LAS_CONFIG_FILE liblas-config)
	IF(LAS_CONFIG_FILE)
		MARK_AS_ADVANCED(LAS_CONFIG_FILE)

		SET(CMAKE_MRPT_HAS_LIBLAS 1)
		SET(CMAKE_MRPT_HAS_LIBLAS_SYSTEM 1)

		# Get the config params:
		EXECUTE_PROCESS(COMMAND ${LAS_CONFIG_FILE} --libs
			RESULT_VARIABLE CMAKE_LAS_CONFIG_RES
			OUTPUT_VARIABLE CMAKE_LAS_LIBS
			OUTPUT_STRIP_TRAILING_WHITESPACE
			)
		IF(${CMAKE_LAS_CONFIG_RES})
			MESSAGE("Error invoking LAS config file:\n ${LAS_CONFIG_FILE} --libs")
		ENDIF(${CMAKE_LAS_CONFIG_RES})

		EXECUTE_PROCESS(COMMAND ${LAS_CONFIG_FILE} --includes
			RESULT_VARIABLE CMAKE_LAS_CONFIG_RES
			OUTPUT_VARIABLE CMAKE_LAS_INCLUDES
			OUTPUT_STRIP_TRAILING_WHITESPACE
			)
		IF(${CMAKE_LAS_CONFIG_RES})
			MESSAGE("Error invoking LAS config file:\n ${LAS_CONFIG_FILE} --includes")
		ENDIF(${CMAKE_LAS_CONFIG_RES})

		# Join all flags and parse to separate them:
		SET(CMAKE_LAS_CFGS "${CMAKE_LAS_LIBS} ${CMAKE_LAS_INCLUDES}")

		pkgconfig_parse(${CMAKE_LAS_CFGS} "LAS")

		# For some reason, "liblas-config --libs" return all other libs, except liblas itself:
		LIST(APPEND LAS_LIBS "las")

		IF($ENV{VERBOSE})
			MESSAGE(STATUS "liblas configuration:")
			MESSAGE(STATUS "  LAS_INCLUDE_DIRS: ${LAS_INCLUDE_DIRS}")
			MESSAGE(STATUS "  LAS_LINK_DIRS: ${LAS_LINK_DIRS}")
			MESSAGE(STATUS "  LAS_LIBS: ${LAS_LIBS}")
		ENDIF($ENV{VERBOSE})

		APPEND_MRPT_LIBS(${LAS_LIBS})
		LINK_DIRECTORIES(${LAS_LINK_DIRS})
		INCLUDE_DIRECTORIES(${LAS_INCLUDE_DIRS})

	ELSE(LAS_CONFIG_FILE)
		SET(CMAKE_MRPT_HAS_LIBLAS 0)
	ENDIF(LAS_CONFIG_FILE)
ELSE(UNIX)
	# Windows: (Not supported for now)
	SET(CMAKE_MRPT_HAS_LIBLAS 0)
ENDIF(UNIX)
