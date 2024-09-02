module dice(
    output reg [5:0] out = 6'b000000,
    output reg unsigned[5:0] integer_out,
    output reg unsigned[5:0] mod_6,
    output reg unsigned[5:0] prev_mod_6,
    output reg [6:0] seg,
    input clk,
    input rst
);
    integer a = 1;
    wire feedback;
    assign feedback = ~(out[5] ^ out[4]);

    always @(posedge clk or posedge rst) begin
	    if (rst) begin
		  out <= 6'b000000;
		  integer_out <= 6'b000000; // Reset the integer_out as well
	    end else begin
		  out[0] <= out[1];
		  out[1] <= out[2];
		  out[2] <= out[3];
		  out[3] <= out[4];
		  out[4] <= out[5];
		  out[5] <= feedback;
		  
		  integer_out = out[5] * 32 + out[4] * 16 + out[3] * 8 + out[2] * 4 + out[1] * 2 + out[0];
	    end
      end
	
	always @(posedge clk or posedge rst) begin

	    if (rst) begin
		  mod_6 = integer_out % 6;
		  if (mod_6 == 0) begin
			mod_6 = 1;
		  end
	    end else begin
		  mod_6 = integer_out % 6;
		  if (mod_6 == 0) begin
			mod_6 = a;
			a <= a + 1;
			if(a == 6)
			begin
				a <= 1;
			end
		  end
		  if (prev_mod_6 == mod_6)begin
			mod_6 = mod_6 + 1;
		  end
	    end
	    prev_mod_6 <= mod_6;
	end
	
    always @(posedge clk or posedge rst)
    begin
	  if(rst) begin
	  seg <= 7'b0000000;
	  end
	  else
	  begin
        case (mod_6) 
         
            1 : seg = 7'b0000001;
            2 : seg = 7'b0000010;
            3 : seg = 7'b0000011;
            4 : seg = 7'b0000100;
            5 : seg = 7'b0000101;
            6 : seg = 7'b0000110;
		
        endcase
	  end
    end
    
endmodule