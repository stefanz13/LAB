module test;
  
  high_payload_frames hpf= new;
  base_packet packet_q;
  uart_packet packet_q_u = new;
  initial begin    
    int fr_pos;
    bit [4:0] len;
    packet_q = packet_q_u;
    
    for (int i = 0;i<5;i++) begin
      len = $urandom();
      packet_q_u.pop();
      packet_q.populate(len);
    end
    
    for (int i = 0; i<15;i++) begin
      fr_pos = $urandom_range(packet_q.frames_q.size());
      hpf.randomize(payload);
      hpf.parity = hpf.xor_pay(hpf.payload);
      hpf.parity=hpf.corrupt(hpf.parity);
      packet_q.replace_frame(hpf, fr_pos - 1);
    end
    
    packet_q.print();
    packet_q.check_frame_corruption();
    
    
  end
endmodule
