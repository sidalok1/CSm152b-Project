import argparse

if __name__=='__main__':
    par = argparse.ArgumentParser()
    par.add_argument("coe", nargs="*")
    par.add_argument("-o")
    args = par.parse_args()
    mem = "memory_initialization_radix = 10;\nmemory_initialization_vector =\n"
    for file in args.coe:
        with open(file, "r") as f:
            vec = f.readlines()[2:]
            vec = vec[:-1] + [vec[-1][:-1]]
            mem = mem + "".join(vec) + ",\n"
    mem = mem[:-2] + ';'
    with open(args.o, "w") as f:
        f.write(mem)