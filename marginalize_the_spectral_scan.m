function [band1, band2, band3, band4] = marginalize_the_spectral_scan (magn_spectr_D)

% input: the amplittude FFT of sgment differences, scanned through DoA
% candidates
% ouput: marginalized energy scans in 4 different frequency bands:

% ------
% input is a 683 x 101 matrix, 683 are the freq bin indices, calculated 
% at NFFT = 2049, Fs = 2048
% ---
% 683 ...16000 Hz
% 512 ...12000 Hz
% 342 ... 8000 Hz
% 256 ... 6000 Hz
% 171 ... 4000 Hz
% 128 ... 3000 Hz
% 86  ... 2000 Hz
% 43  ... 1000 Hz.
% 21  ...  500 Hz

Spectr_slice_1 = magn_spectr_D (3:43, :);
band1 = sum(Spectr_slice_1, 1);
band1 = band1 ./ 41;

Spectr_slice_2 = magn_spectr_D (43:86, :);
band2 = sum(Spectr_slice_2, 1);
band2 = band2 ./ 44;

Spectr_slice_3 = magn_spectr_D (86:128, :);
band3 = sum(Spectr_slice_3, 1);
band3 = band3 ./ 44;

Spectr_slice_4 = magn_spectr_D (128:171, :);
band4 = sum(Spectr_slice_4, 1);
band4 = band4 ./ 44;

figure(5)

% plotting spectrogram slices:

subplot(241)
imagesc(Spectr_slice_1)
title ('Spectrogram slice')
xlabel('DoA scan [samples]'); ylabel ('1000Hz .................. 0Hz')

subplot(242)
imagesc(Spectr_slice_2)
title ('Spectrogram slice')
xlabel('DoA scan [samples]'); ylabel ('2kHz ..................... 1kHz')

subplot(243)
imagesc(Spectr_slice_3)
title ('Spectrogram slice')
xlabel('DoA scan [samples]'); ylabel ('3kHz ..................... 2kHz')

subplot(244)
imagesc(Spectr_slice_4)
title ('Spectrogram slice,')
xlabel('DoA scan [samples]'); ylabel ('4kHz ..................... 3kHz')

% plotting the DoA scan curves

subplot(245)
plot(band1)
xlabel ('DoA scan [samples]'); ylabel ('Band 1: E(chA) - (chB))')
grid on

subplot(246)
plot(band2)
xlabel ('DoA scan [samples]'); ylabel ('Band 2: E(chA) - (chB))')
grid on

subplot(247)
plot(band3)
xlabel ('DoA scan [samples]'); ylabel ('Band 3: E(chA) - (chB))')
grid on

subplot(248)
plot(band4)
xlabel ('DoA scan [samples]'); ylabel ('Band 4: E(chA) - (chB))')
grid on