


module NEOPIX
#(parameter num_Pixels = 1,
short_pulse = 4,
long_pulse = 12,
RET = 800)
(
  input  wire clk,
  input  wire [23:0] PIX_DAT,
  output wire out);

reg [9:0] counter;
reg [5:0] pointer;

initial begin
	counter = 0;
	pointer = 23;
end

always @ (posedge clk) begin

counter <= counter + 1;


$display("pointer: %d, counter: %d, data: %d", pointer, counter, PIX_DAT[pointer]);

if(pointer >= 0 & pointer <= 23) begin


	if( PIX_DAT[pointer] == 0) begin

		if(counter < short_pulse) out <= 1;
		else if(counter >= short_pulse && counter < short_pulse + long_pulse) out <= 0;
		else if(counter >= short_pulse + long_pulse) begin
			counter <= 0;
			pointer <= pointer - 1;
		end

	end else if(PIX_DAT[pointer] == 1) begin

		if(counter < long_pulse) out <= 1;
		else if(counter >= long_pulse && counter < short_pulse + long_pulse) out <= 0;
		else if(counter >= short_pulse + long_pulse) begin
			counter <= 0;
			pointer <= pointer - 1;
		end

	end else begin
		out <= 1'b0;
		//remove since this will never be reached in real hardware
	end
end else out <= 1'b0;

//check to see if pointer is at the end and if it is output 0
//if it isnt at the end operate normally

end

endmodule


//4   time ticks for 0.4us
//2  time ticks for 0.85us
//800 time ticks for 50us
