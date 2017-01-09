set(LIBSNDFILE_DIR "${SDK_DIR}/Audio/libsndfile")
set(PORTAUDIO_DIR "${SDK_DIR}/Audio/portaudio")
set(LIBSNDFILE_DLL_NAME libsndfile-1.dll)
set(LIBSNDFILE_LIB_NAME libsndfile-1.lib)

if(WIN64)
	set(PORTAUDIO_DLL_NAME portaudio_x64.dll)
	set(PORTAUDIO_LIB_NAME portaudio_x64.lib)
	set(PORTAUDIO_PLATFORM_FOLDER_NAME win64)
elseif(WIN32)
	set(PORTAUDIO_DLL_NAME portaudio_x86.dll)
	set(PORTAUDIO_LIB_NAME portaudio_x86.lib)
	set(PORTAUDIO_PLATFORM_FOLDER_NAME win32)
endif()

if(WIN32 OR WIN64)
	add_library(libsndfile SHARED IMPORTED GLOBAL)
	set_target_properties(libsndfile PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${LIBSNDFILE_DIR}/include)
	
	set(LIBSNDFILE_DLL_PATH ${LIBSNDFILE_DIR}/lib/${PORTAUDIO_PLATFORM_FOLDER_NAME}/${LIBSNDFILE_DLL_NAME})
	set(LIBSNDFILE_LIB_PATH ${LIBSNDFILE_DIR}/lib/${PORTAUDIO_PLATFORM_FOLDER_NAME}/${LIBSNDFILE_LIB_NAME})
	set_target_properties(libsndfile PROPERTIES IMPORTED_LOCATION ${LIBSNDFILE_DLL_PATH})
	set_target_properties(libsndfile PROPERTIES IMPORTED_IMPLIB ${LIBSNDFILE_LIB_PATH})
	
	add_library(PortAudio SHARED IMPORTED GLOBAL)
	set_target_properties(PortAudio PROPERTIES INTERFACE_LINK_LIBRARIES libsndfile INTERFACE_INCLUDE_DIRECTORIES ${PORTAUDIO_DIR}/inc)
	
	set_property(TARGET PortAudio APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
	set(PORTAUDIO_DLL_PATH ${PORTAUDIO_DIR}/lib/${PORTAUDIO_PLATFORM_FOLDER_NAME}/release/${PORTAUDIO_DLL_NAME})
	set(PORTAUDIO_LIB_PATH ${PORTAUDIO_DIR}/lib/${PORTAUDIO_PLATFORM_FOLDER_NAME}/release/${PORTAUDIO_LIB_NAME})
	set_target_properties(PortAudio PROPERTIES IMPORTED_LOCATION_RELEASE ${PORTAUDIO_DLL_PATH})
	set_target_properties(PortAudio PROPERTIES IMPORTED_IMPLIB_RELEASE ${PORTAUDIO_LIB_PATH})
	
	set_property(TARGET PortAudio APPEND PROPERTY IMPORTED_CONFIGURATIONS PROFILE)
	set(PORTAUDIO_DLL_PATH ${PORTAUDIO_DIR}/lib/${PORTAUDIO_PLATFORM_FOLDER_NAME}/release/${PORTAUDIO_DLL_NAME})
	set(PORTAUDIO_LIB_PATH ${PORTAUDIO_DIR}/lib/${PORTAUDIO_PLATFORM_FOLDER_NAME}/release/${PORTAUDIO_LIB_NAME})
	set_target_properties(PortAudio PROPERTIES IMPORTED_LOCATION_PROFILE ${PORTAUDIO_DLL_PATH})
	set_target_properties(PortAudio PROPERTIES IMPORTED_IMPLIB_PROFILE ${PORTAUDIO_LIB_PATH})
	
	set_property(TARGET PortAudio APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
	set(PORTAUDIO_DLL_PATH ${PORTAUDIO_DIR}/lib/${PORTAUDIO_PLATFORM_FOLDER_NAME}/debug/${PORTAUDIO_DLL_NAME})
	set(PORTAUDIO_LIB_PATH ${PORTAUDIO_DIR}/lib/${PORTAUDIO_PLATFORM_FOLDER_NAME}/debug/${PORTAUDIO_LIB_NAME})
	set_target_properties(PortAudio PROPERTIES IMPORTED_LOCATION_DEBUG ${PORTAUDIO_DLL_PATH})
	set_target_properties(PortAudio PROPERTIES IMPORTED_IMPLIB_DEBUG ${PORTAUDIO_LIB_PATH})
endif()

macro(copy_portaudio)
	if (WIN32 OR WIN64)
		file(TO_NATIVE_PATH "${OUTPUT_DIRECTORY}" NATIVE_OUTDIR)
		file(TO_NATIVE_PATH "${LIBSNDFILE_DIR}" NATIVE_LIBSNDFILE)
		file(TO_NATIVE_PATH "${PORTAUDIO_DIR}" NATIVE_PORTAUDIO)
		add_custom_command(TARGET ${THIS_PROJECT} PRE_BUILD
		COMMAND copy /Y ${NATIVE_LIBSNDFILE}\\lib\\${PORTAUDIO_PLATFORM_FOLDER_NAME}\\${LIBSNDFILE_DLL_NAME} ${NATIVE_OUTDIR}
		COMMAND copy /Y ${NATIVE_PORTAUDIO}\\lib\\${PORTAUDIO_PLATFORM_FOLDER_NAME}\\$<$<NOT:$<CONFIG:Debug>>:release>$<$<CONFIG:Debug>:debug>\\${PORTAUDIO_DLL_NAME} ${NATIVE_OUTDIR})
	else()
		message(WARNING "PortAudio library copy not implemented for this platform!")
	endif()
endmacro()