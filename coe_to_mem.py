import argparse

if __name__=="__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("inp")
    parser.add_argument("out")
    parser.add_argument("-i", type=int)
    parser.add_argument("-o", type=int)
    parser.add_argument("-k", type=int)
    parser.add_argument("-pre", type=str)
    parser.add_argument("-dec", action='store_true')
    args = parser.parse_args()
    I = args.i
    O = args.o
    K = args.k
    print(f"{args.inp}, {args.out}, {args.pre}: {I = }, {O = }, {K = }")
    with open(args.inp, "r") as infile:
        f = infile.readlines()[2:]
        
        for i in range(I):
            for j in range(O):
                with open(f"{args.out}/{args.pre}_{i}-{j}.mem", "w") as outfile:
                    mat = list()
                    for k in range(K):
                        line = list()
                        for kk in range(K):
                            ind = ((i * O * (K ** 2)) + (j * (K ** 2)) + (k * K) + kk)
                            #print(f"{ind = }:\t(({i} * {O} * ({K} ** 2)) + ({j} * ({K} ** 2)) + ({k} * {K}) + {kk})")
                            n = f[ind].strip()
                            #print(n)
                            num = n[:-1]
                            if (args.dec):
                                inum = int(num)
                                num = f"{inum:02X}"
                            line.append(num)
                        mat.append(" ".join(line))
                    outfile.write("\n".join(mat))