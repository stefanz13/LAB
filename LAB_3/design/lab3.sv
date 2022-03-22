class frame;
  rand bit [7:0] payload;
  bit parity;
  
  
  function frame copy;
    copy = new();
    copy.payload = this.payload;
    copy.parity   = this.parity;
    return copy;
  endfunction
  
  function bit xor_pay (bit [7:0] payload);
    parity = 0;
    parity = ^payload;
  return parity;
  endfunction
  
  function bit corrupt (bit parity);
    parity = parity ^ 1;
    return parity;
  endfunction
  
  function int check_parity (bit [7:0] payload, bit parity);
    bit par_bit = 0;
    par_bit = ^payload;
    
    if (par_bit == parity)
      return 0;

     else
      return -1;
  endfunction
  
endclass

class start_frame extends frame;
  function new();
    super.payload = 8'hFF;
  endfunction
endclass

class end_frame extends frame;
  function new();
    super.payload = 8'hFE;
  endfunction
endclass

class high_payload_frames extends frame;

  constraint range {payload dist {[8'h00:8'hF0] :/ 1,[8'hF1:8'hFF] :/ 10};}
  
endclass

class base_packet;
  frame frames_q [$];
  bit [4:0] queue_lenth; 
  
  task populate(bit [4:0] queue_lenth); 
    frame pl = new();
    frame pl_c = new();
    for (int i = 0; i<queue_lenth; i++) begin
      pl_c = pl.copy();
      pl_c.randomize(payload);
      pl_c.parity = pl_c.xor_pay(pl_c.payload);
      frames_q.push_back(pl_c);
    end
  endtask
  
  function void print();
    
    foreach(frames_q[i]) $display("\tpayload[%0d] = %b parity = %b",i, frames_q[i].payload,frames_q[i].parity);
  endfunction
  
  function void replace_frame(frame fr, int num);
    frames_q[num].payload= fr.payload;
    frames_q[num].parity= fr.parity;
  endfunction
  
  virtual function void check_frame_corruption();
  endfunction
  
  
endclass

class uart_packet extends base_packet;
  
  function void pop();
    start_frame start = new;
    end_frame end_ = new;
    frame fr1 = new;
    
    super.populate(8);

    super.frames_q.delete(0);
    super.frames_q.push_front(start);
    
    super.frames_q.delete(7);
    super.frames_q.push_back(end_);
    
  endfunction
  
  function void check_frame_corruption ();
    frame fr_check = new();
    int counter = 0;
    foreach(frames_q[i]) begin
      int a=fr_check.check_parity(frames_q[i].payload,frames_q[i].parity);
      if (a == -1) begin
        counter++;
        $display("\tFRAME ON POSITION %0d IS CORRUPTED",i);
      end
    end
    $display("\n\tIN PACKET HAVE %0d CORRUPTED FRAMES",counter);
    
  endfunction
  
 
endclass

  





