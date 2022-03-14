module test;
  
  high_payload_frames hpf= new;
  base_packet packet_q = new;
  uart_packet packet_q_u = new;
  initial begin    
    
    packet_q = packet_q_u;
    packet_q_u.pop();
    packet_q_u.pop();
    packet_q.populate(5'b01011);
   
    for (int i = 0; i<15;i++) begin
      hpf.randomize(payload);
      hpf.parity = hpf.xor_pay(hpf.payload);
      hpf.parity=hpf.corrupt(hpf.parity);
      packet_q.replace_frame(hpf, i);
    end
    
    foreach(packet_q_u.frames_q[i])
      packet_q.check_frame_corruption(packet_q.frames_q[i].payload,packet_q.frames_q[i].parity);
      
    
  end
endmodule
