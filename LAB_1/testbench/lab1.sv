module test;
  Packet test1;
  Packet test2;
  Memory mem;
  initial begin
    
    test2 = new(20,32'h200,INCREMENT);
    test1 = new(10,32'h100,FIXED);
    mem = new();
    
    test1.print();
    mem.write(test1);
    mem.read(32'h100,10);
    
    test2.print();
    mem.write(test2);
    mem.read(32'h200,20);
    
    
    
  end
endmodule
