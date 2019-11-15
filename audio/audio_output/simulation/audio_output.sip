set_global_assignment -entity "audio_output" -library "lib_audio_output" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "audio_output" -library "lib_audio_output" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "audio_output" -library "lib_audio_output" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_audio_output" -name SPD_FILE [file join $::quartus(sip_path) "../audio_output.spd"]
set_global_assignment -library "lib_audio_output" -name MISC_FILE [file join $::quartus(sip_path) "../../audio_output.qsys"]

set_global_assignment -library "lib_audio_output" -name MISC_FILE [file join $::quartus(sip_path) "audio_output.v"]
set_global_assignment -library "lib_audio_output" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_audio_bit_counter.v"]
set_global_assignment -library "lib_audio_output" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_audio_in_deserializer.v"]
set_global_assignment -library "lib_audio_output" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_audio_out_serializer.v"]
set_global_assignment -library "lib_audio_output" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_clock_edge.v"]
set_global_assignment -library "lib_audio_output" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_sync_fifo.v"]
set_global_assignment -library "lib_audio_output" -name MISC_FILE [file join $::quartus(sip_path) "submodules/audio_output_audio_0.v"]
