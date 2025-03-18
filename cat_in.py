

with open("mem/in42_0-0.mem", "r") as f1:
    with open("mem/in123_0-0.mem", "r") as f2:
        with open("mem/in789_0-0.mem", "r") as f3:
            with open("mem/in.mem", "w") as fo:
                fo.write("\n\n".join([f1.read(), f2.read(), f3.read()]))