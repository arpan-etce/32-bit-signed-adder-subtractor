module add_sub_8bit(
    input [7:0] a,b,
    input cin,control,
    output [7:0] sum,
    output cout
    );

    wire [7:0] bxor;
    assign bxor = {8{control}} ^ b;

    wire c1,c2,c3,c4,c5,c6,c7,c8;

    // Instantiating the full adder
    full_adder fa0(a[0],bxor[0],cin,sum[0],c1),
               fa1(a[1],bxor[1],c1,sum[1],c2),
               fa2(a[2],bxor[2],c2,sum[2],c3),
               fa3(a[3],bxor[3],c3,sum[3],c4),
               fa4(a[4],bxor[4],c4,sum[4],c5),
               fa5(a[5],bxor[5],c5,sum[5],c6),
               fa6(a[6],bxor[6],c6,sum[6],c7),
               fa7(a[7],bxor[7],c7,sum[7],c8);

    assign cout = c8;

endmodule
