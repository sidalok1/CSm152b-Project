import numpy as np
import torch

def rev(l):
    x = l.copy()
    x.reverse()
    return x

kernel = torch.tensor(
    [
        [2, 3, 1],
        [1, 0, 2],
        [-6, -1, 1]
    ], dtype=torch.float32
)

inputs = [
    torch.tensor(
        [
            [1, 2, 3, 4, 5],
            [6, 7, 8, 9, 10],
            [11, 12, 13, 14, 15],
            [16, 17, 18, 19, 20],
            [21, 22, 23, 24, 25]
        ], dtype=torch.float32
    ), 
    torch.tensor(
        [
            [-1, -2, -3, -4, -5],
            [-6, -7, -8, -9, -10],
            [-11, -12, -13, -14, -15],
            [-16, -17, -18, -19, -20],
            [-21, -22, -23, -24, -25]
        ], dtype=torch.float32
    ),
    torch.tensor(
        [
            rev([1, 2, 3, 4, 5]),
            rev([6, 7, 8, 9, 10]),
            rev([11, 12, 13, 14, 15]),
            rev([16, 17, 18, 19, 20]),
            rev([21, 22, 23, 24, 25])
        ], dtype=torch.float32
    ),
    torch.tensor(
        [
            [1, 0, -1, 0, 1],
            [0, 1, 0, 1, 0],
            [-1, 0, 1, 0, -1],
            [0, -1, 0, -1, 0],
            [1, 0, -1, 0, 1]
        ], dtype=torch.float32
    )
]
    
def Output_shape(image, kernel, padding, stride): 
    h,w = image.shape[-2],image.shape[-1] 
    k_h, k_w = kernel.shape[-2],kernel.shape[-1] 
  
    h_out = (h-k_h-2*padding)//stride[0] +1
    w_out = (w-k_w-2*padding)//stride[1] +1
    return h_out,w_out 

def conv2d(image, kernel):
    output_shape = Output_shape(image, kernel, 0, (1, 1))
    output = np.zeros(output_shape)
    for i in range(output_shape[0]): 
        for j in range(output_shape[1]): 
            output[i,j]=torch.tensordot(image[i:3+i,j:3+j],kernel).numpy()
    return output

if __name__=='__main__':
    outs = list(map(lambda m: conv2d(m, kernel), inputs))
    print(f"kernel =\n{kernel.numpy()}")
    for i in range(len(inputs)):
        print(f"Input {i}:\n{inputs[i].numpy()}\nwith output:\n{outs[i]}")