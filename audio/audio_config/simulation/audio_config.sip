set_global_assignment -entity "audio_config" -library "lib_audio_config" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "audio_config" -library "lib_audio_config" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "audio_config" -library "lib_audio_config" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_audio_config" -name SPD_FILE [file join $::quartus(sip_path) "../audio_config.spd"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "../../audio_config.qsys"]

set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "audio_config.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_serial_bus_controller.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_slow_clock_generator.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_auto_init.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_auto_init_dc2.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_auto_init_d5m.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_auto_init_lcm.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_auto_init_ltm.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_auto_init_ob_de1_soc.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_auto_init_ob_de2_115.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_auto_init_ob_de2i_150.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_auto_init_ob_de10_standard.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_auto_init_ob_audio.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_auto_init_ob_adv7180.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_av_config_auto_init_ob_adv7181.v"]
set_global_assignment -library "lib_audio_config" -name MISC_FILE [file join $::quartus(sip_path) "submodules/audio_config_audio_and_video_config_0.v"]
