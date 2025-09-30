# CanSat-Challenges-Matlab
Matlab Code to process Sensor Data from CanSat -- (tested on v2024a)

1. Run the program from main.m.

2. Place your sensor data processing code inside esp32_packet_callback.m.

3. To properly terminate the program and release the serial port, use stopSerialPort.m (otherwise the COM port may remain locked).

4. Optionally, run delete(s) to ensure the COM port is fully released.
 
