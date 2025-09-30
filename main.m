g = 9.8;
pkt_cntr = 1;
N_mag_calib = 000;
fs = 25;  % sample rate

packet_size = 76;
plotRate = 10;
plotSkip = round(fs / plotRate);


delete(serialportfind);
s = serialport("COM3",115200);
configureTerminator(s,"CR/LF");
%pause (3);   % Wait for status messages from Arduino to Accumulate

numBytes = s.NumBytesAvailable;
if(numBytes > 0)
    rawData = read(s, numBytes, "uint8");   % Read status messages before configuring callback
end
fprintf('%d Bytes of status messages flushed \n', numBytes);
flush(s);

% delete(findall(0));   % Close All Previously opened GUIs


% Setup track plot
hLine = plot3(NaN,NaN,NaN,'b-','LineWidth',1.5);
grid on; axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Cube Real-time Trajectory');
% --- Set UP GUIs
hGUI = initRawSensorGUI(s);




s.UserData = struct( "initialized" , false,  "dt", 1/fs, "packet_size", packet_size, "pkt_cntr", 1,  "g", 9.8, ...
    "samples_for_scale_and_bias_calibration", 210, "ax_offset", 0.0, "ay_offset", 0.0, "az_offset", 0.0, ...                             % Empirically Determined Offset -- Applied at the source
    "accMean", ones(1,3), "accBias", zeros(1,3), "gyroMean", zeros(1,3), "buffer", uint8([]),  ...
    "hLine", hLine, "track", zeros(0,3), "plotCounter", 0, "plotSkip", 20, "GUI_RAW", hGUI, ...
    "nSampleMagnetometerCalibration", N_mag_calib, "mx", zeros(1,N_mag_calib), "my", zeros(1,N_mag_calib), "mz", zeros(1,N_mag_calib), "k",1, "magx_offset", -6.5, "magy_offset", -17.5, "magz_offset", -12.0, ...
    "fApplyAccCorrection", 0, "fApplyGyroCorrection", 1, "fApplyMagCorrection",0, "tStart" ,0, "lastTimeStamp", single(0) ...
    );



% Set Up Gyro Monitor
 initGyroGUI(s); 


% Call back after packet is received
configureCallback(s,  "byte", s.UserData.packet_size, @esp32_packet_callback)