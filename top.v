// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,      // 16MHz clock
    output LED,     // User/boot LED next to power LED
    output USBPU,   // USB pull-up resistor
    output PIN_18   //neopixel
);
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    //reg [7:0] R, G, B;
    //initial R = 8'd255;
    //initial G = 8'd255;
    //initial B = 8'd0;


  
    //reg [23:0] counter;
    //initial counter = 24'd0;
	//
	//
	////assign LED = state;
	//
	//always @ (posedge CLK) begin
	//counter = counter + 1;
	//	if(counter >= 16_000_000) begin
	//		counter = 24'b0;
	//		//state = ~state;
	//	end
	//	
	//end
    


	/*
		this feels like a hacky solution.
		I am unsure if I should send it one pixels worth of data at a time,
		or if I should send it a buffer for all pixels in the strip
	*/
	reg [23:0] data;
	initial data = {8'd0, 8'd64, 8'd64};
			//8'd64, 8'd64, 8'd0,
			//8'd64, 8'd0, 8'd64};

	//NEOPIX neo(CLK, {G, R, B}, PIN_18);
	NEOPIX neo(CLK, data, PIN_18);
	//this module should report when its resetting and when it is on the last bit for a pixel


endmodule
