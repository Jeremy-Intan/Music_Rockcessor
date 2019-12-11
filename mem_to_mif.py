print("WIDTH=16;")
print("DEPTH=65536;")
print("")
print("ADDRESS_RADIX=UNS;")
print("DATA_RADIX=BIN;")
print("")

f = open("program.mem", "r")
lines = f.readlines()
print("CONTENT BEGIN")
lnno = 0
for line in lines:
    print("    {} : {};".format(lnno, line.replace("\n", "")))
    lnno+=1

if lnno < 65535:
    print("    [{}..65535] : 0000000000000000;".format(lnno))
elif lnno == 65336:
    print(" 65535 : 0000000000000000;")

print("END;")
