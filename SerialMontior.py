import serial
from datetime import datetime

serial_port = '/dev/ttyACM0';
baud_rate = 115200;
write_TO_FILE_PATH = "log.txt";

output_file = open(write_TO_FILE_PATH, "w+");
ser = serial.Serial(serial_port, baud_rate)
while True:
	line = ser.readline();
	print(str(datetime.now())+","+line);
	output_file.write(str(datetime.now())+","+line);