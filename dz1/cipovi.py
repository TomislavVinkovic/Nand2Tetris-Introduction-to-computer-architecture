with open('./BitShiftL.hdl', 'w') as f:
    f.write('CHIP BitShiftL {\n')
    f.write('IN in[16];\n')
    f.write('OUT out[16];\n')
    f.write('PARTS:\n')
    f.write('Mux(a=in[0], b=false, sel=true, out=out[0]);\n')
    for i in range(1, 16):
        f.write(f'Mux(a=in[{i}], b=in[{i-1}], sel=true, out=out[{i}]);\n')
    f.write('}')



with open('./BitShiftR.hdl', 'w') as f:
    f.write('CHIP BitShiftR {\n')
    f.write('IN in[16];\n')
    f.write('OUT out[16];\n')
    f.write('PARTS:\n')
    f.write('Mux(a=in[15], b=false, sel=true, out=out[15]);\n')
    for i in range(14, -1, -1):
        f.write(f'Mux(a=in[{i}], b=in[{i+1}], sel=true, out=out[{i}]);\n')
    f.write('}')
