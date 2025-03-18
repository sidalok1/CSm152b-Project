import torch
import torch.nn as nn
import torch.nn.functional as F

# Define the model class that was used to save the model
class OptimizedCNN(nn.Module):
    def __init__(self):
        super(OptimizedCNN, self).__init__()
        self.conv1 = nn.Sequential(
            nn.Conv2d(in_channels=1, out_channels=16, kernel_size=3),  # Reduced filters and kernel size
            nn.BatchNorm2d(16),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2)
        )
        
        self.conv2 = nn.Sequential(
            nn.Conv2d(in_channels=16, out_channels=32, kernel_size=3),  # Reduced filters and kernel size
            nn.BatchNorm2d(32),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2)
        )
        
        self.fc = nn.Sequential(
            nn.Flatten(),
            nn.Linear(32 * 5 * 5, 10),
            nn.Softmax()
        )
    
    def forward(self, x):
        x = self.conv1(x)
        x = self.conv2(x)
        x = self.fc(x)
        return x

# Load your final INT8 model
# If it's already converted, each weight param should be an int8 or quint8 Tensor
model = torch.load('model_dynamic_quantized.pth', map_location='cpu')
model.eval()

# Print the model parameters to check their data types
for name, param in model.named_parameters():
    print(name, param.shape, param.dtype)

# If you saved a state_dict, do:
# state_dict = torch.load('model_int8.pth', map_location='cpu')
# model = OptimizedCNN()  # your architecture
# model.load_state_dict(state_dict)
# model.eval()

# A helper to write a tensor to a .coe file in hex
def write_tensor_to_coe(tensor, filename):
    # Since our model wasn't properly quantized to int8, we'll manually 
    # quantize the float32 tensors to int8 range for .coe file generation
    
    # Get the tensor data and convert to numpy
    data = tensor.data.cpu().numpy().flatten()
    
    # Simple min-max quantization to int8 range (-128 to 127)
    data_max = data.max()
    data_min = data.min()
    scale = max(abs(data_max), abs(data_min)) / 127.0  # Scale to fit in int8
    
    # Quantize the data to int8 range
    quantized_data = (data / scale).round().astype('int8')
    
    with open(filename, 'w') as f:
        f.write("memory_initialization_radix=16;\n")
        f.write("memory_initialization_vector=\n")
        for i, val in enumerate(quantized_data):
            # Convert signed int8 into two-hex-digit string
            # val & 0xFF ensures you get 0..255
            hex_val = f"{(val & 0xFF):02X}"
            
            # Add comma for all except the last element
            if i < len(quantized_data) - 1:
                f.write(hex_val + ",\n")
            else:
                f.write(hex_val + ";")
                
        print(f"Wrote {len(quantized_data)} values to {filename}")
        print(f"Used scale factor: {scale}")

# Now write the weights to .coe files
write_tensor_to_coe(model.conv1[0].weight, 'conv1_weights.coe')
write_tensor_to_coe(model.conv1[0].bias, 'conv1_bias.coe')
write_tensor_to_coe(model.conv2[0].weight, 'conv2_weights.coe')
write_tensor_to_coe(model.conv2[0].bias, 'conv2_bias.coe')
write_tensor_to_coe(model.fc[1].weight, 'fc_weights.coe')
write_tensor_to_coe(model.fc[1].bias, 'fc_bias.coe')