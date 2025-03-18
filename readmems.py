readkerns1 = list()
for i in range(16):
    readkerns1.append(f"$readmemh(\"k1_0-{i}.mem\", conv1.kernels[0][{i}]);")
readkerns2 = list()
for i in range(16):
    for j in range(32):
        readkerns2.append(f"$readmemh(\"k2_{i}-{j}.mem\", conv2.kernels[{i}][{j}]);")

with open("readmems.vh", "w") as f:
    f.write("\n".join(readkerns1 + readkerns2))