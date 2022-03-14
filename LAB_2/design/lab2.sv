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

typedef class Configuration;

class Memory;
  bit [511:0][31:0] mem;
  Packet packet;
  reg [15:0]ENABLE;
  reg [15:0] THRESHOLD_ADDRESS;
  reg [15:0] THRESHOLD_LENGHT;
  reg [15:0] RESET;
  
  function void write(Packet packet);
    for (int i=0; i<packet.packet_lenght; i++) begin
      mem[packet.start_address+i] = packet.q[i];
    end
    
  endfunction
  
  function void read(bit[31:0] start_address, int packet_lenght); 
    
    $display("\t mem  = %b",mem[start_address]);
  
  endfunction
  
  function void corrupt (bit[31:0] memory_location_index,int memory_bit_position_index);
    mem[memory_location_index][memory_bit_position_index] = mem[memory_location_index][memory_bit_position_index] ^ 1;
  endfunction
  
  function void check (bit[31:0] memory_location,bit parity);
    bit [31:0] mem_copy = mem[memory_location];
    bit par_bit = 0;
    for (int i = 0; i <32; i++) begin
      par_bit = par_bit ^ mem_copy[i];
    end
    if (par_bit == parity)
      $display("\t CHECK PASSED!");
    else
      $display("\t CHECK FAIL!");
  endfunction
  
  function void configure (Configuration conf);
    if (conf.direction == 1) begin
      case(conf.address)
        00: this.ENABLE = conf.data;
        01: this.THRESHOLD_ADDRESS = conf.data;
        10: this.THRESHOLD_LENGHT = conf.data;
        11: this.RESET = conf.data;
      endcase
    end
    if (conf.direction == 0) begin
      
      case(conf.address)
        00: $display("\t reg ENABLE  = %b",ENABLE);
        01: $display("\t reg THRESHOLD_ADDRESS  = %b",THRESHOLD_ADDRESS);
        10: $display("\t reg THRESHOLD_LENGHT = %b",THRESHOLD_LENGHT);
        11: $display("\t reg RESET  = %b",RESET);
      endcase
    end

  endfunction
endclass
typedef enum {READ,WRITE} direct;
class Configuration;
  bit [1:0] address;
  direct direction;
  bit [15:0] data;
  
  function new (bit [1:0] address,direct direction,bit [15:0] data);
    this.address = address;
    this.direction = direction;
    this.data = data;
    
  endfunction
  
endclass
          



