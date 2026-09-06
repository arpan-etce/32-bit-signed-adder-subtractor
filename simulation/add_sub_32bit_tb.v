module add_sub_32bit_tb;
    reg [31:0] a;
    reg [31:0] b;
    reg        control;
    wire [31:0] sum;
    wire        cout;

  reg [32:0] expected;  //expected result

    integer errors;
    integer tests;
    integer i;

    add_sub_32bit dut (
        .a(a),
        .b(b),
        .control(control),
        .sum(sum),
        .cout(cout)
    );
    
    task check;
        input [31:0] test_a;
        input [31:0] test_b;
        input        test_control;

        begin
            a = test_a;
            b = test_b;
            control = test_control;

            #1;

            // Reference model
            if (test_control == 1'b0)
                expected = {1'b0,test_a} + {1'b0,test_b};
            else
                expected = {1'b0,test_a} +
                           {1'b0,~test_b} +
                           33'd1;

            tests = tests + 1;

            if ((sum !== expected[31:0]) ||
                (cout !== expected[32])) begin

                $display("ERROR:");
                $display("  control = %b", test_control);
                $display("  a       = %h", test_a);
                $display("  b       = %h", test_b);
                $display("  Expected: sum=%h cout=%b",
                         expected[31:0], expected[32]);
                $display("  Actual:   sum=%h cout=%b",
                         sum, cout);

                errors = errors + 1;
            end
        end
    endtask


    initial begin

        errors = 0;
        tests  = 0;
      
        $display("32-BIT ADD/SUB TEST STARTED");

        $display("Testing ADDITION...");

        check(32'h00000000, 32'h00000000, 1'b0);
        check(32'h00000000, 32'h00000001, 1'b0);
        check(32'h00000001, 32'h00000001, 1'b0);
        check(32'h000000FF, 32'h00000001, 1'b0);
        check(32'h00000100, 32'h00000100, 1'b0);

        check(32'hFFFFFFFF, 32'h00000000, 1'b0);
        check(32'hFFFFFFFF, 32'h00000001, 1'b0);
        check(32'hFFFFFFFF, 32'hFFFFFFFF, 1'b0);

        check(32'h7FFFFFFF, 32'h00000001, 1'b0);
        check(32'h80000000, 32'h80000000, 1'b0);

        check(32'hAAAAAAAA, 32'h55555555, 1'b0);
        check(32'h55555555, 32'hAAAAAAAA, 1'b0);

        check(32'h12345678, 32'h87654321, 1'b0);
        check(32'hDEADBEEF, 32'h12345678, 1'b0);


        $display("Testing SUBTRACTION...");

        check(32'h00000000, 32'h00000000, 1'b1);
        check(32'h00000001, 32'h00000000, 1'b1);
        check(32'h00000001, 32'h00000001, 1'b1);
        check(32'h00000005, 32'h00000003, 1'b1);

        check(32'h00000100, 32'h00000001, 1'b1);
        check(32'h00010000, 32'h00000001, 1'b1);
        check(32'h01000000, 32'h00000001, 1'b1);

        check(32'hFFFFFFFF, 32'h00000001, 1'b1);
        check(32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1);

        check(32'h80000000, 32'h00000001, 1'b1);
        check(32'h7FFFFFFF, 32'hFFFFFFFF, 1'b1);

        check(32'hAAAAAAAA, 32'h55555555, 1'b1);
        check(32'h55555555, 32'hAAAAAAAA, 1'b1);

        check(32'h12345678, 32'h87654321, 1'b1);
        check(32'hDEADBEEF, 32'h12345678, 1'b1);




        $display("Testing RANDOM CASES...");

        for (i = 0; i < 10000; i = i + 1) begin

            check(
                $random,
                $random,
                1'b0
            );

            check(
                $random,
                $random,
                1'b1
            );

        end
       
        $display("TESTS COMPLETED");
        $display("Total tests = %0d", tests);
        $display("Total errors = %0d", errors);

        if (errors == 0)
            $display("******** ALL TESTS PASSED ********");
        else
            $display("******** TEST FAILED ********");
      
        $finish;
    end
endmodul
