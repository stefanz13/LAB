module mem;
  Packet test1;
  Packet test2;
  Memory mem;
  Configuration conf;
  initial begin
    
    test2 = new(20,32'h200,INCREMENT);
    test1 = new(10,32'h100,FIXED);
    mem = new();
    
    test1.print();
    mem.write(test1);
    mem.read(32'h100,10);
    mem.corrupt(32'h100,10);
    mem.check(32'h100,1);
    
    
    test2.print();
    mem.write(test2);
    mem.read(32'h200,20);
    
    conf = new(2'b01,WRITE,16'h0011);
    mem.configure(conf);
    conf.direction = READ;
    conf.address = 2'b01;
    
    mem.configure(conf);
    
  end
endmodule
