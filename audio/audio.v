
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module audio(

	//////////// Audio //////////
	input 		          		AUD_ADCDAT,
	inout 		          		AUD_ADCLRCK,
	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK,

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// I2C for Audio and Video-In //////////
	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS
	
	/*
	input [7:0] bpm_in,
	input [1:0] curr_note_beats_in,
	input [20:0] curr_note_freq_in
	*/
);

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire audio_rst;
wire [15:0] amplitude;

reg [1:0] write_addr;

reg [20:0] counter = 0;
reg [15:0] write_wave;

reg [2:0] state = 0;
reg [2:0] next_state = 1;
localparam RESET = 0;
localparam WAIT_FOR_NOTE = 1;
localparam PLAY_NOTE = 2;
localparam CHECK_DONE_PLAYING_NOTE = 3;
localparam F = 4;

reg [10:0] bpm_in; // set the bpm of music
reg [2:0] curr_note_beats_in = 2; // do actual number of expected beats
reg [20:0] curr_note_freq_in; // frequency of note. a "1" is taken as PLAY NO NOTE.

reg [3:0] stim_counter = 0; // added for testing

wire reset; // INPUT - active high resets music device
reg [10:0] bpm = 500; // INPUT - stores music tempo as BEATS PER MINUTE. Error if this is set to 0;
reg [2:0] curr_note_beats = 0; // INPUT - set to the number of beats for the current note
reg [20:0] curr_note_freq = 1; // INPUT - set to the frequency of the current note.  = 50 MHz / {desired note freq}
localparam clocks_per_minute = 50000000 * 60; // 50 MHz * 60 seconds per minute = clocks per minute
wire [31:0] clocks_per_beat; // allows down to 1 bpm
reg [31:0] note_length_counter = 0; // count clocks to count the number of beats played
reg [2:0] beats_played_counter = 0; // count the number of beats played to know when to stop the note

// fill curr_note_freq with these maybe? user selects a number 1-8?
localparam c_low = 191117;
localparam d = 170265;
localparam e_flat = 160710;
localparam e = 151690;
localparam f = 143176;
localparam g = 127551;
localparam a_flat = 120395;
localparam a = 113636;
localparam b_flat = 107259;
localparam b = 101239;
localparam c_high = 95555;
localparam d_flat_high = 90194;
localparam d_high = 85132;
localparam e_flat_high = 80352;
localparam e_high = 75843;
localparam f_high = 71586;

//=======================================================
//  Structural coding
//=======================================================

assign amplitude = (((state == PLAY_NOTE) || (state == CHECK_DONE_PLAYING_NOTE)) && (curr_note_freq != 1)) ? 16'h3FFF : 16'h0000;

assign clocks_per_beat = clocks_per_minute / bpm;


// TESTING STIMULUS 
always @ (posedge CLOCK_50) begin
	if (reset) begin
		bpm_in <= 500; // clocked at 16th notes for "Keg in the Closet"
		curr_note_beats_in = 1;
		stim_counter <= 0;
		curr_note_freq_in <= a_flat;
	end
	else if (state == F) begin
		// could put these in a different always @ block ?
		stim_counter <= (stim_counter > 11) ? 12 : stim_counter + 1;
	end
	// use registers to set a sequence of notes by frequency and length
	case (stim_counter)
		11: curr_note_freq_in <= f;
		10: begin curr_note_freq_in <= a; curr_note_beats_in <= 4; end
		9: begin curr_note_freq_in <= g; curr_note_beats_in <= 2; end
		8: begin curr_note_freq_in <= 1; curr_note_beats_in <= 1; end
		7: begin curr_note_freq_in <= f; curr_note_beats_in <= 3; end
		6: begin curr_note_freq_in <= f; curr_note_beats_in <= 2; end
		5: curr_note_freq_in <= c_low;
		4: begin curr_note_freq_in <= e; curr_note_beats_in <= 4; end
		3: begin curr_note_freq_in <= d; curr_note_beats_in <= 2; end
		2: begin curr_note_freq_in <= 1; curr_note_beats_in <= 1; end
		1: begin curr_note_freq_in <= c_low; curr_note_beats_in <= 3; end
		0: curr_note_freq_in <= c_low;
		default: curr_note_beats_in <= 0;
	endcase
end

// reset on a switch for now, should be put in from master for normal operation
assign reset = ~KEY[3];
assign LEDR[0] = reset;
// seeing how note lengths line up
assign LEDR[1] = (curr_note_beats == 1) ? 1 : 0;
assign LEDR[2] = (curr_note_beats == 2) ? 1 : 0;
assign LEDR[3] = (curr_note_beats == 3) ? 1 : 0;
assign LEDR[4] = (curr_note_beats == 4) ? 1 : 0;

// set next state for state machine
always @ (*) begin
	case (state)
		RESET: next_state <= WAIT_FOR_NOTE;
		WAIT_FOR_NOTE: begin
			if (curr_note_beats == 0) next_state <= WAIT_FOR_NOTE;
			else next_state <= PLAY_NOTE;
		end
		PLAY_NOTE: begin
			if (note_length_counter < clocks_per_beat) next_state <= PLAY_NOTE;
			else next_state <= CHECK_DONE_PLAYING_NOTE;
		end
		CHECK_DONE_PLAYING_NOTE: begin
			if (beats_played_counter >= curr_note_beats) next_state <= F;
			else next_state <= PLAY_NOTE;
		end
		default: next_state <= WAIT_FOR_NOTE;
	endcase
end

// state operations and outputs
always @ (posedge CLOCK_50) begin	
	if (reset)
		state <= RESET;
	else 
		state <= next_state;
		case (state)
		RESET: begin
			bpm <= 120;
			curr_note_beats <= 0;
			curr_note_freq <= 1;
			note_length_counter <= 0;
			beats_played_counter <= 0;
		end
		WAIT_FOR_NOTE: begin
			bpm <= bpm_in;
			curr_note_beats <= curr_note_beats_in;
			curr_note_freq <= curr_note_freq_in;
		end
		PLAY_NOTE: begin
			note_length_counter <= note_length_counter + 1;
		end
		CHECK_DONE_PLAYING_NOTE: begin
			beats_played_counter <= beats_played_counter + 1;
			note_length_counter <= 0;
		end
		default: begin // F
			curr_note_beats <= 0;
			note_length_counter <= 0;
			beats_played_counter <= 0;
			// have notes wait until completion of a wave to cut off?
		end
		endcase
end

	
always @ (posedge CLOCK_50) begin	
// set 50% duty cycle for a square wave. Could try and make a cosine wave later. 
if (counter <= (curr_note_freq >> 1))
	write_wave <= amplitude;
else
	write_wave <= 20'h00000;
// control the counter for note
if (state != WAIT_FOR_NOTE) begin
	if (counter >= curr_note_freq)
		counter <= 20'h00000;
	else
		counter <= counter + 1;
end
else
	counter <= 20'h00000;

//	write same data to the right and left sides  
	if (write_addr == 2'b10)
		write_addr <= 2'b11;
	else
		write_addr <= 2'b10;
end

// IP to generate a slower clock for the AV chip
audio_clk (
		.audio_clk_clk(AUD_XCK),      //    audio_clk.clk
		.ref_clk_clk(CLOCK_50),        //      ref_clk.clk
		.ref_reset_reset(reset),    //    ref_reset.reset
		.reset_source_reset(audio_rst)  // reset_source.reset
	);

// IP to output through AV chip
audio_output (
		.address(write_addr),     // avalon_audio_slave.address
		.chipselect(1'b1),  //                   .chipselect
//		input  wire        read,        //                   .read
		.write(1'b1),       //                   .write
		.writedata({16'b0,write_wave}),
//		output wire [31:0] readdata,    //                   .readdata
		.clk(CLOCK_50),
		.AUD_BCLK(AUD_BCLK),    // external_interface.BCLK
		.AUD_DACDAT(AUD_DACDAT),  //                   .DACDAT
		.AUD_DACLRCK(AUD_DACLRCK), //                   .DACLRCK
//		output wire        irq,         //          interrupt.irq
		.reset (audio_rst)		       //              reset.reset
	);

// IP to auto-config the AV chip
audio_config (
//		input  wire [1:0]  address,     // avalon_av_config_slave.address
//		input  wire [3:0]  byteenable,  //                       .byteenable
//		input  wire        read,        //                       .read
//		input  wire        write,       //                       .write
//		input  wire [31:0] writedata,   //                       .writedata
//		output wire [31:0] readdata,    //                       .readdata
//		output wire        waitrequest, //                       .waitrequest
		.clk(CLOCK_50),         //                    clk.clk
		.I2C_SDAT(FPGA_I2C_SDAT),    //     external_interface.SDAT
		.I2C_SCLK(FPGA_I2C_SCLK),    //                       .SCLK
		.reset(audio_rst)        //                  reset.reset
	);

endmodule
