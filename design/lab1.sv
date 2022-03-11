//change
typedef enum {FIXED,INCREMENT} burst_t; //enumeration
class Packet; 
  int packet_lenght;
  bit [31:0] start_address;
  burst_t field;
  bit [31:0] q[$];
  //constructor
  function new(int packet_lenght,bit[31:0] start_address,burst_t field);
    this.start_address = start_address;
    this.packet_lenght = packet_lenght;
    this.field = field;
    for (int i=0; i<packet_lenght; i++) begin
      q[i]=start_address + i;
    end
  endfunction
  
  function void print();
    $display("\t addr = %0h",start_address);
    $display("\t lenght  = %0d",packet_lenght);
    $display("\t field  = %0s",field.name);
    
  endfunction
endclass

class Memory;
  bit [511:0][31:0] mem;
  Packet packet;
  
 
  function void write(Packet packet);
    for (int i=0; i<packet.packet_lenght; i++) begin
      mem[packet.start_address+i] = packet.q[i];
    end
    
  endfunction
 
  function void read(bit[31:0] start_address,int packet_lenght); 
    
    $display("\t mem  = %0h",mem[start_address]);
  
  endfunction
endclass


