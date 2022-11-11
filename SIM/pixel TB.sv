`timescale 1ns/1ns
module neopixel_TB();

logic clk;

reg [7:0] R, G, B;
logic out;

NEOPIX neo(clk, {B, R, G}, out);

always #31.25 clk = !clk;


initial begin

$dumpfile("waves.vcd");
$dumpvars;

clk = 0;

R = 8'b10101010;
G = 8'b10101010;
B = 8'b10101010;

#10;

#500;

end




endmodule