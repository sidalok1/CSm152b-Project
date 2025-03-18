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
    ),
    torch.tensor(
        [list(range(i, i-6, -1)) for i in range(-1, -((6**2)+1), -6)],
        dtype=torch.float32
    )
]
    
def Output_shape(image, kernel, padding, stride): 
    h,w = image.shape[-2],image.shape[-1] 
    k_h, k_w = kernel.shape[-2],kernel.shape[-1] 
  
    h_out = (h - k_h + (2*padding) + stride[0]) // stride[0]
    w_out = (w - k_w + (2*padding) + stride[1]) // stride[1]
    return h_out,w_out 

def conv2d(image, kernel):
    output_shape = Output_shape(image, kernel, 0, (1, 1))
    output = np.zeros(output_shape)
    for i in range(output_shape[0]): 
        for j in range(output_shape[1]): 
            output[i,j]=torch.tensordot(image[i:3+i,j:3+j],kernel).numpy()
    return output

def relu(input):
    output_shape = input.shape[-2], input.shape[-1] 
    output = np.zeros(output_shape)
    for i in range(output_shape[0]): 
        for j in range(output_shape[1]): 
            output[i,j] = max(input[i, j], 0)
    return output

def maxpool(input, kshape, padding, s):
    h,w = input.shape[-2], input.shape[-1] 
    k_h, k_w = kshape
    h_out = (h - k_h + (2*padding) + s[0]) // s[0]
    w_out = (w - k_w + (2*padding) + s[1]) // s[1]
    output = np.zeros((h_out, w_out))
    for i in range(h_out):
        for j in range(w_out):
            output[i, j] = max(list(map(max, input[i*s[0]:i*s[0]+k_h, j*s[1]:j*s[1]+k_w])))
    return output
if __name__=='__main__':
    inter1 = list(map(lambda m: conv2d(m, kernel), inputs))
    inter2 = list(map(relu, inter1))
    outs = list(map(lambda m: maxpool(m, (2,2), 0, (2,2)), inter2))
    print(f"kernel =\n{kernel.numpy()}")
    for i in range(len(inputs)):
        print(f"Input {i}:\n{inputs[i].numpy()}\n\
convolution:\n{inter1[i]}\n\
relu:\n{inter2[i]}\n\
maxpool:\n{outs[i]}")