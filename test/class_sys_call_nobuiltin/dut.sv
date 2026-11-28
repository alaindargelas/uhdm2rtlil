// read_sv runs Surelog with -nobuiltin; a system call in a class method was
// then "Undefined system task/function" (CP0333) and the read failed.
class logger;
  local int count;
  function void note(int v);
    count++;
    $display("%0d %0d", count, v);
  endfunction
endclass
module class_sys_call_nobuiltin(input logic [7:0] a, output logic [7:0] y);
  assign y = ~a;
endmodule
