module PWM_shift_register(
	input clock,
	output [7:0] PWM
);

reg [7:0] counter = 0;
reg [2:0] i = 0 ;
integer difdutcyc [7:0] ;
reg shireg [7:0] ; 

initial begin
	difdutcyc[0] = 9;
	difdutcyc[1] = 19;
	difdutcyc[2] = 28;
	difdutcyc[3] = 37;
	difdutcyc[4] = 47;
	difdutcyc[5] = 56;
	difdutcyc[6] = 66;
	difdutcyc[7] = 75;
end

initial begin
	shireg[0] = 0;
	shireg[1] = 0;
	shireg[2] = 0;
	shireg[3] = 0;
	shireg[4] = 0;
	shireg[5] = 0;
	shireg[6] = 0;
	shireg[7] = 0;
end

reg latch = 0;
reg reset = 0;
reg shiin = 0;

always @(posedge clock) begin
	if(counter < 100) counter <= (counter + 1);
	else counter <= 0;	
end

//assign PWM = (counter < 20) ? 1 : 0; 

ShiftReg Shift (clock, latch, reset, shiin, PWM);

always @(negedge clock) begin
	if(counter < difdutcyc[i])
	    shiin = 1;
	else
        shiin = 0;
        i = (i + 1) ; 
	if(i == 0) begin
		latch = 1;
		#1 latch = 0;
	end	
end
endmodule

module ShiftReg(
    input clock, latch, reset,
	input shiin,
	output reg [7:0] latreg
);

reg [7:0] D;

initial begin
	D = 8'b0;
	latreg=8'b0;
end

always @(posedge clock) begin
	if(reset==1) begin
		D <= 8'b0;
		latreg <= 8'b0;
	end
	else begin
		D[0] <= shiin;
		D[1] <= D[0];
		D[2] <= D[1];
		D[3] <= D[2];
		D[4] <= D[3];
		D[5] <= D[4];
		D[6] <= D[5];
		D[7] <= D[6];
	end
end

always @(posedge latch) latreg <= D ;

endmodule

module PWM_Shift_Register_Test_Bench;

	// Inputs
	reg clock;

	// Outputs
	wire [7:0] PWM;

	// Instantiate the Unit Under Test (UUT)
	PWM_shift_register uut (
		.clock(clock), 
		.PWM(PWM)
	);

	initial begin
		// Initialize Inputs
		clock = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#5000000 $finish;
	end

    always #10 clock = ~clock;

endmodule