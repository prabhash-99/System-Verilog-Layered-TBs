//Design - Asynchronus FIFO

module  async_fifo #(parameter WIDTH = 8,
                               DEPTH = 16,
                               SIZE = $clog2(DEPTH),
							                 DIFF = 2
                    )
                   (input wr_clk, rd_clk,
                    input rstn, 
                    input wr_en, rd_en,
                    input [WIDTH-1'b1 : 0] wr_data,
                    output reg [WIDTH-1'b1 : 0] rd_data,
          					output reg full, empty, almost_full, almost_empty,
					          output overflow, underflow
                    );

    reg [WIDTH-1'b1:0] mem [0 : DEPTH-1'b1];
    reg [SIZE : 0] wr_ptr, rd_ptr;
	wire [SIZE : 0] g_wr_ptr, g_rd_ptr;
	reg [SIZE : 0] wr_ptr_1, rd_ptr_1;
	reg [SIZE : 0] wr_ptr_3, rd_ptr_3;
	wire [SIZE : 0] wr_ptr_2, rd_ptr_2;

	assign g_wr_ptr = binary_grey(wr_ptr);
	assign rd_ptr_2 = grey_binary(rd_ptr_1);
	assign g_rd_ptr = binary_grey(rd_ptr);
	assign wr_ptr_2 = grey_binary(wr_ptr_1);
  assign overflow = (wr_en && full) ? 1 : 0;
  assign underflow = (rd_en && empty) ? 1 : 0;

	function reg [SIZE : 0] binary_grey(input [SIZE :0] ptr_value);
	integer i;
	begin
		i = 0;
		binary_grey[SIZE] = ptr_value[SIZE];
		repeat(SIZE) begin
			binary_grey[i] = (ptr_value[i] ^ ptr_value[i+1'b1]);
			i = i + 1'b1;
		end
	end
	endfunction

	function reg [SIZE : 0] grey_binary(input [SIZE :0] ptr_value);
	integer i; 
	begin
		i = SIZE-1'b1;
		grey_binary[SIZE] = ptr_value[SIZE];
		repeat(SIZE) begin
			grey_binary[i] = (ptr_value[i] ^ grey_binary[i+1'b1]);
			i = i - 1'b1;
		end
	end
	endfunction

	always @(posedge wr_clk or negedge rstn) begin
		if(!rstn) begin
			wr_ptr <= 'd0;
			full <= 1'b0;
			almost_full <= 1'b0;
//			overflow <= 1'b0;
		end
		else if(wr_en && !full) begin
			mem[wr_ptr[SIZE-1'b1 : 0]] <= wr_data;
			wr_ptr <= wr_ptr + 1'b1;
		end
	end

	always @(posedge rd_clk or negedge rstn) begin
		if(!rstn) begin
			rd_ptr <= 'd0;
			empty <= 1'b1;
			rd_data <= 'd0;
			almost_empty <= 1'b0;
//			underflow <= 1'b0;
		end
		else if(rd_en && !empty) begin
			rd_data <= mem[rd_ptr[SIZE-1'b1 : 0]] ;
			rd_ptr <= rd_ptr + 1'b1;
		end
	end

	always @(posedge wr_clk or negedge rstn) begin
		if(!rstn) begin
			rd_ptr_1 <= 'd0;
			rd_ptr_3 <= 'd0;
		end
		else begin	
			rd_ptr_3 <= g_rd_ptr;
			rd_ptr_1 <= rd_ptr_3;
		end

	end

	always @(posedge rd_clk or negedge rstn) begin
		if(!rstn) begin
			wr_ptr_1 <= 'd0;
			wr_ptr_3 <= 'd0;
		end
		else begin	
			wr_ptr_3 <= g_wr_ptr;
			wr_ptr_1 <= wr_ptr_3;
		end

	end

	always @(posedge wr_clk or negedge rstn or wr_ptr or rd_ptr_2) begin

//		if(wr_en && full)
//			overflow = 1'b1;

		if((wr_ptr[SIZE] != rd_ptr_2[SIZE]) && (wr_ptr[SIZE-1'b1 : 0] == rd_ptr_2[SIZE-1'b1 : 0])) begin
			full = 1'b1;
		end
		else begin
			full = 1'b0;
		end

		if(wr_ptr[SIZE] != rd_ptr_2[SIZE]) begin
			if(((rd_ptr_2[SIZE-1'b1:0] - wr_ptr[SIZE-1'b1:0]) <= DIFF) && (!full))
				almost_full = 1'b1;
			else
				almost_full = 1'b0;
		end
		else begin
			if(((wr_ptr[SIZE-1'b1:0] - rd_ptr_2[SIZE-1'b1:0]) >= (DEPTH - DIFF)) && (!full))
				almost_full = 1'b1;
			else
				almost_full = 1'b0;
		end

//		if(!full)
//			overflow = 1'b0;

	end

	always @(posedge rd_clk or negedge rstn or rd_ptr or wr_ptr_2) begin

//		if(rd_en && empty)
//			underflow = 2'b1;

		if(rd_ptr == wr_ptr_2) begin
			empty = 1'b1;
		end
		else begin
			empty = 1'b0;
		end

		if(rd_ptr[SIZE] != wr_ptr_2[SIZE]) begin
			if(((rd_ptr[SIZE-1'b1:0] - wr_ptr_2[SIZE-1'b1:0]) >= (DEPTH-DIFF)) && !empty)
				almost_empty = 1'b1;
			else
				almost_empty = 1'b0;
		end
		else begin
			if(((wr_ptr_2[SIZE-1'b1:0] - rd_ptr[SIZE-1'b1:0]) <= DIFF) && !empty)
				almost_empty = 1'b1;
			else
				almost_empty = 1'b0;
		end

//		if(!empty)
//			underflow = 1'b0;
	end

endmodule
