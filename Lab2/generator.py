## a code generator for the ALU chain in the 32-bit ALU
## look at example_generator.py for inspiration
## 
## python generator.py
def print_wires(num):
    string =  "wire"
    for i in range(1, num):
        string+= " w" + str(i) + ","
    string+= " w" + str(num) + ";"
    print(string)

def print_alu_chain(num):
    for i in range(1, num):
        print("alu1 a" + str(i) + "(" + "out" + "[" + str((i)) + "]," + "w" + str(i + 1) + "," + "A[" + str((i)) + "]" + "," + "B[" + str((i)) + "]" + "," + "w" + str(i) + ",control" + ");")

def print_zero_flag(num):
    string = "nor nor1(zero"
    for i in range(num):
        string += ", out[" + str(i) + ']'
    print(string + ");")
print_zero_flag(32)

def print_dffe_chain(num):
    for i in range(0, num):
        print("dffe d" + str(i) + "(" + "q" + "[" + str((i)) + "]," + "d[" + str((i)) + "]" + ", clk, enable, reset);")

print_dffe_chain(32)