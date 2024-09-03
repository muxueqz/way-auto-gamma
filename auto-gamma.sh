#!/bin/bash

# 初始化变量，保存上一次的灰度值
monitor=$(i3-msg -t get_outputs | jello | grep '"name"' | cut -d'"' -f4 | head -1)

previous_gray_value=0
screenshot_file=/dev/shm/screenshot-for-adjust.png

while true; do
	# 截图保存为screenshot.png
	grim -l 0 -o $monitor $screenshot_file

	# 获取灰度值
	gray_value=$(python3 get-gray.py $screenshot_file)
	# 计算灰度值的差异
	difference=$((gray_value - previous_gray_value))

	# 如果灰度值大于50，且与上次的值不同，则设置gamma
	if [[ $difference -gt 20 || $difference -lt -20 || $previous_gray_value -eq 0 ]]; then
		if [[ $gray_value -gt 150 ]]; then
			gamma_value=0.4
		elif [[ $gray_value -gt 100 ]]; then
			gamma_value=0.5
		elif [[ $gray_value -gt 50 ]]; then
			gamma_value=0.6
		else
			gamma_value=0.8
		fi
		killall wlsunset
		wlsunset -g $gamma_value -l 26.0960622048 -L 119.3065881729 -t 4500 &
		# killall redshift
		# redshift -g $gamma_value:$gamma_value:$gamma_value -l 26.0960622048:119.3065881729 -o &
		echo "Gamma set to $gamma_value due to gray value: $gray_value"
	fi

	# 更新上次的灰度值
	previous_gray_value=$gray_value

	# 每秒循环一次
	sleep 0.5
done
gamma_value=1.0
wlsunset -g $gamma_value -l 26.0960622048 -L 119.3065881729 -t 4500
