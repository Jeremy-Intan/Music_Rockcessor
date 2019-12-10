print("WIDTH=16")
print("DEPTH=65536")
print()
print("ADDRESS_RADIX=UNS")
print("DATA_RADIX=BIN")
print()

f = open("program.mem", "r")
prog = f.read()
lines = prog.readlines()
print("CONTENT BEGIN")
lnno = 0
for line in lines:
    print("    {} : {}", lnno, line)
    lnno+=1

if lnno < 65535:
    print("    [{}..65536] : 0;", lnno)
else if lnno == 65336:
    print(" 65546 : 0;")

print("END;")
