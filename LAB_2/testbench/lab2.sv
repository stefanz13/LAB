module mem;
  Packet test1;
  Packet test;
  Memory mem;
  Configuration conf;
  initial begin
    bit [31:0] p_add;
    int p_len;
    int th_len;
    int cor_pos;
    int cor_add;
    bit [31:0] th_add;
    mem=new();
    
    
    conf = new(2'b00,WRITE,16'h0001);
    mem.configure(conf);
    for (int i=0;i<5;i++) begin
      p_add = $urandom_range(511);
      th_add = $urandom_range(511);
      p_len = $urandom_range(10,1);
      th_len = $urandom_range(10,1);
      cor_pos = $urandom_range(31);
      cor_add = $urandom_range(p_len);
      
      test = new(p_len,p_add,INCREMENT);
      test.print();
      conf = new(2'b01,WRITE,th_add);
      mem.configure(conf);
      conf = new(2'b10,WRITE,th_len);
      mem.configure(conf);
      mem.write(test);
      mem.corrupt(p_add+cor_add,cor_pos);
      mem.read(p_add,p_len);
    end
    //reset
    $display(" SET RESET TO 1");
    conf = new(2'b11,WRITE,16'h0001);
    mem.configure(conf);
    mem.write(test);
    mem.read(p_add,1);
    /*
    $display(" SET RESET TO 0");
    conf = new(2'b11,WRITE,16'h0000);
    mem.configure(conf);
    
    $display(" SET THRESHOLD_ADDRESS ON LOWER VALUE THAN PACKET_ADDRESS");
    conf = new(2'b01,WRITE,p_add-p_len);
    mem.configure(conf);
    mem.write(test);
    */
    $display(" PRINTING ALL REGISTERS");
    conf.direction = READ;
    
    conf.address = 2'b00;
    mem.configure(conf);
    conf.address = 2'b01;
    mem.configure(conf);
    conf.address = 2'b10;
    mem.configure(conf);
    conf.address = 2'b11;
    mem.configure(conf);
  end
endmodule
