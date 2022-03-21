typedef enum {FIXED,INCREMENT} burst_t; 
class Packet; 
  int packet_lenght;
  bit [31:0] start_address;
  burst_t field;
  bit [31:0] q[$];
  
  function new(int packet_lenght,bit[31:0] start_address,burst_t field);
    this.start_address = start_address;
    this.packet_lenght = packet_lenght;
    this.field = field;
    
    if (field == INCREMENT) begin
      for (int i=0; i<packet_lenght; i++) begin
        q[i]=start_address + i;
      end
    end
    
    else begin
      for (int i=0; i<packet_lenght; i++) begin
        q[i]=start_address;
      end
    end
    
  endfunction
  
  function void print();
    $display("\t addr = %0h",start_address);
    $display("\t lenght  = %0d",packet_lenght);
    $display("\t field  = %0s",field.name);
    
  endfunction
endclass

typedef class Configuration;

class Memory #(parameter int ADD_NUM = 512, ADD_LEN = 32, REG_DATA = 16);
  bit [ADD_NUM - 1:0][ADD_LEN - 1:0] mem;
  Packet packet;
  bit [ADD_NUM - 1:0] parity;
  reg [REG_DATA - 1:0] ENABLE;
  reg [REG_DATA - 1:0] THRESHOLD_ADDRESS;
  reg [REG_DATA - 1:0] THRESHOLD_LENGHT;
  reg [REG_DATA - 1:0] RESET;
  
  
  function void write(Packet packet);
    if (packet.start_address + packet.packet_lenght >ADD_NUM-1)  $display("\t THE ADDRES DOES NOT EXIST");
    else begin 
    if (ENABLE == 0) $display("\t YOU DON'T HAVE ACCESS TO MEMORY!");
      else if (packet.start_address > THRESHOLD_ADDRESS) $display("\t PACKET ADDRESS IS ABOVE THRESHOLD_ADDRESS!");
    else if (packet.packet_lenght > THRESHOLD_LENGHT) $display("\t PACKET LENGHT IS LONGER THEN THRESHOLD_LENGHT!");
    else if (RESET == 1) begin
      foreach (mem[i]) begin 
        mem[i] = 32'b0;
        parity[i] = 0;
      end
    end
    else begin
      for (int i=0; i<packet.packet_lenght; i++) begin
        mem[packet.start_address+i] = packet.q[i];
        parity[packet.start_address+i] = 0;
        for (int j = 0; j<ADD_LEN; j++) begin
          parity[packet.start_address+i] ^= mem[packet.start_address+i][j];
        end
      end
      
    end
    
    end
    
  endfunction
  
  function void read(bit[ADD_LEN-1:0] start_address, int packet_lenght);
    if (start_address + packet_lenght >ADD_NUM - 1)  $display("\t THE ADDRES DOES NOT EXIST");
    else begin
    if (ENABLE == 1) begin
      for (int i=0;i<packet_lenght; i++) begin
        bit par_bit =0;
        for (int j = 0; j<ADD_LEN; j++) begin
          par_bit ^= mem[start_address+i][j];
        end
        if (par_bit == parity[start_address +i]) begin
          $display("\t mem[%0hh]  = %0b",start_address +i,mem[start_address+i],"\t PARITY CHECK PASSED");
        end
        else $display("\t mem[%0hh]  = %0b",start_address +i,mem[start_address+i],"\t PARITY CHECK FAIL");
      
      end
    end
    else $display("\t YOU DON'T HAVE ACCESS TO MEMORY!");
    end
  endfunction
  
    
  function void corrupt (bit[ADD_LEN - 1:0] memory_location_index,int memory_bit_position_index);
    mem[memory_location_index][memory_bit_position_index] ^=1;
  endfunction
  
  function void configure (Configuration conf);
    if (conf.direction == 1) begin
      case(conf.address)
        2'b00: this.ENABLE = conf.data;
        2'b01: this.THRESHOLD_ADDRESS = conf.data;
        2'b10: this.THRESHOLD_LENGHT = conf.data;
        2'b11: this.RESET = conf.data;
      endcase
    end
    if (conf.direction == 0) begin
      
      case(conf.address)
        2'b00: $display("\t reg ENABLE  = %0b",ENABLE);
        2'b01: $display("\t reg THRESHOLD_ADDRESS  = %0b",THRESHOLD_ADDRESS);
        2'b10: $display("\t reg THRESHOLD_LENGHT = %0b",THRESHOLD_LENGHT);
        2'b11: $display("\t reg RESET  = %0b",RESET);
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

