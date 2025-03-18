with open("fc_weights.coe", "r") as fin:
    l = list(map(lambda x: x[0:2], fin.readlines()[2:]))
    with open("mem/fw_weights.mem", "w") as fout:
        fout.write("\n".join(l))