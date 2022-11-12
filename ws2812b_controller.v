module NEOPIX
#(parameter num_pixels = 3,
T0H = 6,
T0L = 14,
T1H = 13,
T1L = 7,
RES = 880
)
(
  input  wire clk,
  input  wire [71:0] pixel_data,
  output reg out);


//0->1023
reg [9:0] timer;
reg [5:0] bit_pointer;
reg [$clog2(num_pixels):0] pixel_pointer;

initial begin
	timer = 0;
	bit_pointer = 0;
	pixel_pointer = 0;
end


//T0 period
localparam T0_period = T0H + T0L;
//T1 period
localparam T1_period = T1H + T1L;


/*
this always block drives:
	timer,
	bit_pointer,
	out,
	pixel_pointer
*/
always @ (posedge clk) begin



if(pixel_pointer < num_pixels) begin

	timer <= timer + 1;

	if(pixel_data[pixel_pointer * 24 + 23 - bit_pointer] == 1) begin
		//transmit 1
		
		
		if(timer < T1H) 	out <= 1;
		else				out <= 0;

		if(timer == T1_period - 1) begin
			$display("transmitted 1 %0t",$time); 
			timer 				<= 0;

			if(bit_pointer + 1 > 23)begin
				$display("pixel pointer increment %0t",$time); 
				pixel_pointer 			<= pixel_pointer + 1;
				bit_pointer 			<= 0;
			end else begin
				$display("bit pointer increment %0t",$time); 
				bit_pointer 		<= bit_pointer + 1;
			end

		end else begin

		end


	end else begin
		//transmit 0
		

		if(timer < T0H) 	out <= 1;
		else				out <= 0;
		
		if(timer == T0_period - 1) begin
			$display("transmitted 0 %0t",$time); 
			timer 				<= 0;
			

			if(bit_pointer + 1 > 23)begin
				$display("pixel pointer increment %0t",$time); 
				pixel_pointer 			<= pixel_pointer + 1;
				bit_pointer 			<= 0;
			end else begin
				$display("bit pointer increment %0t",$time); 
				bit_pointer 		<= bit_pointer + 1;
			end

				

		end else begin

		end

	end

	if(bit_pointer > 23) begin 
		$display("reset pixel pointer %0t",$time); 
		bit_pointer 			<= 0;
		pixel_pointer 			<= pixel_pointer + 1;
	end


end else begin
	//res pulse

	$display("reset %0t",$time); 

	if(timer <= RES) begin
		timer					<= timer + 1;
		pixel_pointer 			<= pixel_pointer;
	end else begin
		timer 					<= 0;
		pixel_pointer 			<= 0;
	end

	out 						<= 0;
	bit_pointer 				<= 0;

end





end

endmodule


/*
0 code:
/T0H\_T0L_
1 code:
/T1H\_T1L_
RET code
_Treset_
name		timing [us]		timing	[ns]		# of clock pulse		ideal choice			error
				
T0H			0.4  [us]		400		[ns]		5	->	8				6						+-150 [ns]
T1H			0.8  [us]		800		[ns]		11	->	15				13						+-150 [ns]
T0L			0.85 [us]		850		[ns]		12	->	15				14						+-150 [ns]
T1L			0.45 [us]		450		[ns]		5	->	9				7						+-150 [ns]
RES			t>50 [us]		50_000	[ns]		800						810
note:
	810 clock cycles was not a long enough reset time. 850 was the minimum I tested.
note: 50_000 / 62.5 = 800
	must be LONGER than 50_000 ns
16Mhz clock is
62.5ns
*/

//4   time ticks for 0.4us
//2  time ticks for 0.85us
//800 time ticks for 50us