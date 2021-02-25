cmake_minimum_required(VERSION 3.10)

project(shoebill)

list(APPEND macro_files 
	adb fpu mc68851 mem via floppy core_api cpu dis)
list(APPEND raw_files 
	SoftFloat/softfloat atrap_tab coff exception 
	macii_symbols redblack scsi video filesystem alloc_pool 
	toby_frame_buffer ethernet sound)
list(APPEND decoder_files 
	inst dis)

find_package(Threads)
find_package(OpenGL)
find_package(SDL2)

add_executable(decoder_gen ${CMAKE_SOURCE_DIR}/core/decoder_gen.c)
foreach(_decoder_file IN LISTS decoder_files)
	set(OUTFILE ${_decoder_file}_decoder_guts.c)
	add_custom_command(
		OUTPUT ${OUTFILE}
		COMMAND decoder_gen ${_decoder_file} .
		DEPENDS decoder_gen)
	list(APPEND decoder_gen_files ${OUTFILE})
endforeach()
foreach(_macro_file IN LISTS macro_files)
	message(STATUS "Adding Macro File: ${_macro_file}")
	set(INFILE ${CMAKE_SOURCE_DIR}/core/${_macro_file}.c)
	set(OUTFILE ${CMAKE_CURRENT_BINARY_DIR}/${_macro_file}.post.c)
	if("${_macro_file}" STREQUAL "cpu")
		message(STATUS "Adding CPU deps")
		add_custom_command(
			OUTPUT ${OUTFILE}
			COMMAND perl ${CMAKE_SOURCE_DIR}/core/macro.pl
				${INFILE} ${OUTFILE} 
			DEPENDS ${decoder_gen_files})
	else()
		add_custom_command(
			OUTPUT ${OUTFILE}
			COMMAND perl ${CMAKE_SOURCE_DIR}/core/macro.pl
				${INFILE} ${OUTFILE} )
	endif()
	list(APPEND source_files ${OUTFILE})
endforeach()
foreach(_raw_file IN LISTS raw_files)
	list(APPEND source_files "${CMAKE_SOURCE_DIR}/core/${_raw_file}.c")
endforeach()
list(APPEND sdl_source_files ${source_files})
list(APPEND sdl_source_files "${CMAKE_SOURCE_DIR}/sdl-gui/sdl.c")
list(APPEND debugger_source_files ${source_files})
list(APPEND debugger_source_files "${CMAKE_SOURCE_DIR}/debugger/debugger.c")
list(APPEND debugger_source_files "${CMAKE_SOURCE_DIR}/debugger/debugger-glut.c")
set(LIBM_LIBRARIES m)

message(STATUS "Source Files: ${source_files}")
if($ENV{DEBUG})
	add_executable(debugger ${debugger_source_files})
endif()

add_executable(shoebill ${sdl_source_files})
target_link_libraries(shoebill
	Threads::Threads
	OpenGL
	SDL2
	${LIBM_LIBRARIES})
