/* FIFO queue*/
module fifo(clk, Cen, reset, Data_IN, FIFO_Read_Write, FIFO_Empty, FIFO_Full, FIFO_Last, FIFO_Data_Out);
	input clk, Cen, reset, FIFO_Read_Write; //input signals
	input[31:0] Data_IN; //input data

	output FIFO_Empty, FIFO_Full, FIFO_Last; //output signals
	output[31:0] FIFO_Data_Out; // output data

	reg FIFO_Empty, FIFO_Full, FIFO_Last;
	reg[31:0] FIFO_Data_Out;

	reg[31:0] Data[15:0]; //16-slot queue

	reg[4:0] i, cntr, ptr_r, ptr_w; // counter for available space, read/write pointers

	initial begin
		/* initialize pointers */
		ptr_r = 0;
		ptr_w = 0;
		cntr = 0;
		/* initialize output signals */
		FIFO_Full = 1'b0;
		FIFO_Empty = 1'b1;
		FIFO_Last = 1'b0;
		/* initialize queue */
		for (i = 0; i<16; i = i + 1) begin
			Data[i]= 32'b1;
		end
	end

	always@(posedge clk) begin
		/* chip enabled */
		if(Cen == 1'b1) begin
			/*reset queue and pointers*/
			if(reset == 1'b1) begin
				ptr_r = 0;
				ptr_w = 0;
				cntr = 0;
				FIFO_Full = 1'b0;
				FIFO_Empty = 1'b1;
				FIFO_Last = 1'b0;
				for (i = 0; i<16; i = i + 1) begin
					Data[i]= 32'b1;
				end
			end
			/* 0 for write */
			if(FIFO_Read_Write == 1'b0) begin
				FIFO_Data_Out = 32'bx;
				/* diplay available space = 1*/
				if(FIFO_Last == 1'b1) 
					$display("Warning: one more empty slot in queue");
				/* diplay queue is full*/ 
				if(FIFO_Full == 1'b1) begin
					$display("Error: queue is full");
				end
				/* available space = 1*/
				if(cntr == 14) begin
					FIFO_Last = 1'b1;
				end
				else FIFO_Last = 1'b0;
				/* queue not full*/
				if(cntr < 16) begin
					Data[ptr_w] = Data_IN; //add input data in queue
					ptr_w = ptr_w + 1; //increase pointer for next write
					cntr = cntr + 1; // icrease counter for occupied space 
					FIFO_Empty = 1'b0; //queue is not empty anymore
				end
				/*queue full*/
				if(cntr == 16)
					FIFO_Full = 1'b1;
				if(ptr_w >= 16) ptr_w =0;
			end
			/* 1 for read */
			else if(FIFO_Read_Write == 1'b1) begin
				/* if queue is empty*/ 
				if(FIFO_Empty == 1'b1) begin
					$display("Error: queue is empty");
				end
				/* queue not empty */
				if(cntr > 0) begin
					FIFO_Data_Out = Data[ptr_r]; // extract from queue
					ptr_r = ptr_r + 1; // increase read pointer
					cntr = cntr - 1; // decrease counter to free slot
					FIFO_Full = 1'b0; // queue not full anymore
				end
				/* queue is empty*/
				if(cntr == 0) begin
					FIFO_Empty = 1'b1;
				end
				if(ptr_r >= 16) ptr_r = 0;
			end
			/* uknown value in read/write signal*/
			else
				$display("Error: FIFO_Read_Write");
		end
		else begin
			FIFO_Data_Out = 32'bz;
		end
	end

endmodule

/*Top Module*/
module top();
	/* input signals and data for fifo module*/
	reg clk, Cen, reset, FIFO_Read_Write;
	reg[31:0] Data_IN;
	reg[4:0] i;

	/* output signals and data from fifo module*/
	wire FIFO_Empty, FIFO_Full, FIFO_Last;
	wire[31:0] FIFO_Data_Out;

	/*define fifo module*/
	fifo fifo_queue(clk, Cen, reset, Data_IN, FIFO_Read_Write, FIFO_Empty, FIFO_Full, FIFO_Last, FIFO_Data_Out);

	initial
	begin
		/* initialize input signals and data*/
		$dumpfile("fifo.vcd"); //gtkwave
		$dumpvars(0);
		$monitor($time, "|RW=%d, Data_IN=%d, FIFO_Data_Out=%d",FIFO_Read_Write, Data_IN, FIFO_Data_Out);
		clk = 1'b0;
		Cen = 1'b1;
		reset = 1'b0;
		
		/* Insert 10 to FIFO queue */
		i = 0;
		while(i < 10) begin
			#1 clk = ~clk;
				Data_IN = i+1;
				FIFO_Read_Write = 1'b0; /*0 for Write*/
			#1 clk = ~clk;
				i = i + 1;
		end

		/* Extract from FIFO queue*/
		i=0;
		while(i<10) begin
			#1 clk = ~clk;
				FIFO_Read_Write = 1'b1; /*1 for Read*/
			#1 clk = ~clk;
			i = i+1;
		end

		/* Insert 17 to FIFO queue */
		i=0;
		while(i < 17) begin
			#1 clk = ~clk;
				Data_IN = i+1;
				FIFO_Read_Write = 1'b0; /*0 for Write*/
			#1 clk = ~clk;
				i = i + 1;
		end

		/* Extract from FIFO queue*/
		i=0;
		while(i < 17) begin
			#1 clk = ~clk;
				FIFO_Read_Write = 1'b1; /*1 for Read*/
			#1 clk = ~clk;
			i = i+1;
		end

		#1 $finish;
	end
endmodule