module add_sub_32bit(
    input [31:0]a,b,
    input control,
    output [31:0]sum,
    output cout
    );
    wire c1,c2,c3;
    //instantiating the full adder
    add_sub_8bit  a0(a[7:0], b[7:0], control, control, sum[7:0], c1),
                  a1(a[15:8], b[15:8], c1,control, sum[15:8], c2),
                  a2(a[23:16], b[23:16], c2,control, sum[23:16], c3),
                  a3(a[31:24], b[31:24], c3, control, sum[31:24], cout);
    endmodule
