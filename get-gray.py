import sys
from PIL import Image
import numpy as np

# 读取图片
# image_path = 'path_to_your_image.png'
image_path = sys.argv[1]
image = Image.open(image_path)

# 将图片转换为灰度图
gray_image = image.convert('L')

# 转换为numpy数组
gray_array = np.array(gray_image)

# 计算平均灰度值
average_gray_value = np.mean(gray_array)

# print(f"图片的平均灰度值为: {average_gray_value}")
print(int(average_gray_value))
