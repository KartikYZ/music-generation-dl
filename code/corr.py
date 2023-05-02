import scipy.signal

from scipy.io.wavfile import read
import numpy as np

import matplotlib.pyplot as plt

import librosa

def correlation():
    # audio_input_data_one = read("audio/audio/Let It Go/vocals.wav")
    y, sr = librosa.load("audio/audio/Let It Go/vocals.wav")
    y2, sr2 = librosa.load("audio/audio/Let It Go/vocals.out.wav")
    # print(audio_input_data_one)
    # audio_input_data_two = read()
    # print(len(audio_input_data_one[1]))
    # arr = np.array(audio_input_data_one[1],dtype=float)
    print(y.shape, sr)
    print(y2.shape, sr2)
    corr = scipy.signal.fftconvolve(
        y,
        y2,
        mode='full'
    )
    print(corr.shape)
    plt.plot(corr)
    plt.show()

correlation()

