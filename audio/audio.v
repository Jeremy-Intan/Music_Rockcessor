
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
);

//=======================================================
//  REG/WIRE declarations
//=======================================================

reg [10:0] bpm_in; // set the bpm of music
reg [2:0] curr_note_beats_in = 2; // do actual number of expected beats
reg [20:0] curr_note_freq_in; // frequency of note. a "1" is taken as PLAY NO NOTE.

reg [5:0] stim_counter = 0; // added for testing

wire [2:0] state_out;
wire reset; // INPUT - active high resets music device

// fill curr_note_freq with these maybe? user selects a number 1-8?
localparam b_flat_low = 202478;
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


// TESTING STIMULUS 
always @ (posedge CLOCK_50) begin
	if (reset) begin
		bpm_in <= 600; // clocked at 16th notes for "Keg in the Closet"
		curr_note_beats_in = 2;
		stim_counter <= 0;
		curr_note_freq_in <= c_low;
	end
	else if (state_out == 4) begin
		// could put these in a different always @ block ?
		stim_counter <= (stim_counter > 54) ? 55 : stim_counter + 1;
	end
	// use registers to set a sequence of notes by frequency and length
	// don't have to reset both values each time. Will remember from previous cycle.
	case (stim_counter)
	
		53: begin curr_note_freq_in <= 1; curr_note_beats_in <= 5; end
		52: begin curr_note_freq_in <= 1; curr_note_beats_in <= 5; end
		51: begin curr_note_freq_in <= c_low; curr_note_beats_in <= 2; end
		50: begin curr_note_freq_in <= d; curr_note_beats_in <= 2; end
		49: begin curr_note_freq_in <= b_flat_low; curr_note_beats_in <= 2; end
	
		48: begin curr_note_freq_in <= 1; curr_note_beats_in <= 6; end
		47: begin curr_note_freq_in <= 1; curr_note_beats_in <= 6; end
		46: begin curr_note_freq_in <= c_low; curr_note_beats_in <= 4; end
	
		45: begin curr_note_freq_in <= d; curr_note_beats_in <= 2; end
		44: begin curr_note_freq_in <= e; curr_note_beats_in <= 2; end
		43: begin curr_note_freq_in <= f; curr_note_beats_in <= 2; end
		42: begin curr_note_freq_in <= g; curr_note_beats_in <= 2; end
		41: begin curr_note_freq_in <= a; curr_note_beats_in <= 2; end
		40: begin curr_note_freq_in <= 1; curr_note_beats_in <= 1; end
		39: begin curr_note_freq_in <= g; curr_note_beats_in <= 3; end
		38: begin curr_note_freq_in <= g; curr_note_beats_in <= 2; end
	
		37: curr_note_freq_in <= c_high;
		36: begin curr_note_freq_in <= a; curr_note_beats_in <= 4; end
		35: begin curr_note_freq_in <= g; curr_note_beats_in <= 2; end
		34: begin curr_note_freq_in <= 1; curr_note_beats_in <= 1; end
		33: begin curr_note_freq_in <= f; curr_note_beats_in <= 3; end
		32: begin curr_note_freq_in <= f; curr_note_beats_in <= 2; end
	
		31: begin curr_note_freq_in <= c_low; curr_note_beats_in <= 4; end
		30: begin curr_note_freq_in <= e; curr_note_beats_in <= 4; end
		29: begin curr_note_freq_in <= d; curr_note_beats_in <= 2; end
		28: begin curr_note_freq_in <= 1; curr_note_beats_in <= 1; end
		27: begin curr_note_freq_in <= c_low; curr_note_beats_in <= 3; end
		26: begin curr_note_freq_in <= c_low; curr_note_beats_in <= 2; end
	
		25: begin curr_note_freq_in <= d; curr_note_beats_in <= 2; end
		24: begin curr_note_freq_in <= e; curr_note_beats_in <= 2; end
		23: begin curr_note_freq_in <= f; curr_note_beats_in <= 2; end
		22: begin curr_note_freq_in <= g; curr_note_beats_in <= 2; end
		21: begin curr_note_freq_in <= a; curr_note_beats_in <= 2; end
		20: begin curr_note_freq_in <= 1; curr_note_beats_in <= 1; end
		19: begin curr_note_freq_in <= g; curr_note_beats_in <= 3; end
		18: begin curr_note_freq_in <= g; curr_note_beats_in <= 2; end
		
		17: begin curr_note_freq_in <= c_low; curr_note_beats_in <= 4; end
		16: begin curr_note_freq_in <= e; curr_note_beats_in <= 4; end
		15: begin curr_note_freq_in <= d; curr_note_beats_in <= 2; end
		14: begin curr_note_freq_in <= 1; curr_note_beats_in <= 1; end
		13: begin curr_note_freq_in <= c_low; curr_note_beats_in <= 3; end
		12: begin curr_note_freq_in <= c_low; curr_note_beats_in <= 1; end
		
		11: curr_note_freq_in <= f;
		10: begin curr_note_freq_in <= a; curr_note_beats_in <= 4; end
		9: begin curr_note_freq_in <= g; curr_note_beats_in <= 2; end
		8: begin curr_note_freq_in <= 1; curr_note_beats_in <= 1; end
		7: begin curr_note_freq_in <= f; curr_note_beats_in <= 3; end
		6: begin curr_note_freq_in <= f; curr_note_beats_in <= 2; end
		
		5: begin curr_note_freq_in <= c_low; curr_note_beats_in <= 4; end
		4: begin curr_note_freq_in <= e; curr_note_beats_in <= 4; end
		3: begin curr_note_freq_in <= d; curr_note_beats_in <= 2; end
		2: begin curr_note_freq_in <= 1; curr_note_beats_in <= 1; end
		1: begin curr_note_freq_in <= c_low; curr_note_beats_in <= 3; end
		0: begin curr_note_freq_in <= c_low; curr_note_beats_in <= 2; end
		default: curr_note_beats_in <= 0;
	endcase
end

// reset on a switch for now, should be put in from master for normal operation
assign reset = ~KEY[3];
assign LEDR[0] = reset;

/* debugging 
assign LEDR[4:1] = stim_counter;

assign LEDR[1] = (curr_note_beats == 1) ? 1 : 0;
assign LEDR[2] = (curr_note_beats == 2) ? 1 : 0;
assign LEDR[3] = (curr_note_beats == 3) ? 1 : 0;
assign LEDR[4] = (curr_note_beats == 4) ? 1 : 0;
*/

audio_module tester (
//	IP connections
	.AUD_BCLK(AUD_BCLK),
	.AUD_DACDAT(AUD_DACDAT),
	.AUD_DACLRCK(AUD_DACLRCK),
	.AUD_XCK(AUD_XCK),
	.CLOCK_50(CLOCK_50),
	.FPGA_I2C_SCLK(FPGA_I2C_SCLK),
	.FPGA_I2C_SDAT(FPGA_I2C_SDAT),
// signals to interact with state machine
	.bpm_in(bpm_in),
	.curr_note_beats_in(curr_note_beats_in),
	.curr_note_freq_in(curr_note_freq_in),
	.reset(reset),
	.state_out(state_out)
);

endmodule
