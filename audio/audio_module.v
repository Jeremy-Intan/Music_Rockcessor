module audio_module (
	//////////// Audio //////////
	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK,
	input 		          		CLOCK_50,
	//////////// I2C for Audio and Video-In //////////
	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT,

	input [10:0] bpm_in,
	input [2:0] curr_note_beats_in,
	input [20:0] curr_note_freq_in,
	input reset,
	output [2:0] state_out
);


wire audio_rst;
wire [15:0] amplitude;
reg [1:0] write_addr;
reg [15:0] write_wave;
reg [20:0] counter = 0;

reg [2:0] state = 0;
reg [2:0] next_state = 1;
localparam RESET = 0;
localparam WAIT_FOR_NOTE = 1;
localparam PLAY_NOTE = 2;
localparam CHECK_DONE_PLAYING_NOTE = 3;
localparam F = 4;

reg [10:0] bpm = 500; // INPUT - stores music tempo as BEATS PER MINUTE. Error if this is set to 0;
reg [2:0] curr_note_beats = 0; // INPUT - set to the number of beats for the current note
reg [20:0] curr_note_freq = 1; // INPUT - set to the frequency of the current note.  = 50 MHz / {desired note freq}
localparam clocks_per_minute = 50000000 * 60; // 50 MHz * 60 seconds per minute = clocks per minute
wire [31:0] clocks_per_beat; // allows down to 1 bpm
reg [31:0] note_length_counter = 0; // count clocks to count the number of beats played
reg [2:0] beats_played_counter = 0; // count the number of beats played to know when to stop the note

// LOGIC
assign amplitude = (((state == PLAY_NOTE) || (state == CHECK_DONE_PLAYING_NOTE)) && (curr_note_freq != 1)) ? 16'h3FFF : 16'h0000;

assign clocks_per_beat = clocks_per_minute / bpm;
assign state_out = state;

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
