from scipy.fftpack import fft
from scipy.signal import butter, lfilter
import math

def butter_bandpass(lowcut, highcut, fs, order=5):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = butter(order, [low, high], btype='band')
    return b,a

def butter_bandpass_filter(data, lowcut, highcut, fs, order=5)
    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = lfilter(b, a, data)
    return y

def get_windows(data, window_duration, Fs) 
    num_samples_per_window = Fs * window_duration;
    num_samples = math.floor(len(data) / num_samples_per_window)
    
    t_arr = []
    window_arr = []
    for i in range(num_samples)
        start = (i * num_samples_per_window) - num_samples_per_window + 1
        end = (i * num_samples_per_window)
        
        t_arr.append([start:end])
        window_arr.append(data[start:end])
    return t_arr, window_arr

def classifySleep(file)

# Read sleep data file.
data = open(file, 'r');
Fs = 250;
dt = 1/Fs;

filtered_data = butter_bandpass_filter(data, 0.6, 30, Fs, 6)
window_duration = 30; # seconds
windowed_data = get_windows(filtered_data, window_duration, Fs)

data.close();

def sayHello():
print("Hello")


