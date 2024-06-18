
% ---
% Directional Mic Array - DSP implementation
% 2024 03 02 - v.01 : basic 2-channel processing. 
%                   ... using the whole signal spectrum
% -- some thoughts --
% Fs = 48 kHz, ie. apps 7.15 mm spacial resolution.
% Fs = 48 kHz, Nfft = 2048, therefore 23.44Hz/bin .
% micDist1 = 4 x 2.56 mm = 10.24 mm (1.433 samples @ Fs)
% micDist2 = 8 x 2.56 mm = 20.48 mm (2.866 samples @ Fs)
% micDist3 = 15x 2.56 mm = 38.40 mm (5.374 samples @ Fs), example "../Wav/tst 4.wav"
% micDist4 = (12 + 15) x 2.56 mm =  69.72 mm (9.673 samples @ Fs)
%
% read 2-ch data
% [y,Fs] = audioread(filename)
% [y,Fs] = audioread(filename,samples)
read_wav_again = 1;

% -- to do --
% weighted freq. bands
% symmetric delay scan, +/- time-scan
% calculate the final beamformed signal

% --------- read the test wave ----------

disp ('-----------------')

if read_wav_again == 1

    
    
    if 1
    filename = "../Wav/123 stereo 4cm.wav"
    frame_from = 30000          %vxxx
    local_min_in_scan_D = 53;   % optimal inter-channel delay, is read out from the matrix below
    local_min_in_scan_G = 51;   % read out from the matrix below
    end

    if 0
    %filename = "../Wav/ii in_line 4ch.wav"
    %local_min_in_scan_D = 50;   % optimal inter-channel delay, is read out from the matrix below
    %local_min_in_scan_G = 37;   % read out from the matrix below
    end

    if 0
    filename = "../Wav/aa 2024 04 16.wav"
    frame_from = 50000          % 70ooo: One, 110ooo Three
    local_min_in_scan_D = 47;   % optimal inter-channel delay, is read out from the matrix below
    local_min_in_scan_G = 50;   % read out from the matrix below
    end

    if 0
    filename = "../Wav/tst 4.wav"
    frame_from = 110000          % 70ooo: One, 110ooo Three
    local_min_in_scan_D = 46;   % optimal inter-channel delay, is read out from the matrix below
    local_min_in_scan_G = 46;   % read out from the matrix below
    end


    if 0
    filename = "../Wav/aa 4cm perpendic oo1.wav"
    frame_from = 34000
    local_min_in_scan_D = 50;   % optimal inter-channel delay, is read out from the matrix below
    local_min_in_scan_G = 50;   % read out from the matrix below
    end

    if 0
    filename = "../Wav/aa 1cm in line oo1.wav"
    frame_from = 60000
    local_min_in_scan_D = 51;   % optimal inter-channel delay, is read out from the matrix below
    local_min_in_scan_G = 51;   % read out from the matrix below
    end

    if 0
    filename = "../Wav/1234 4cm in line.wav"
    frame_from = 120000
    local_min_in_scan_D = 50;   % optimal inter-channel delay, is read out from the matrix below
    local_min_in_scan_G = 50;   % read out from the matrix below
    end

    if 0
    filename = "../Wav/1234 big array 4ch oo1.wav"
    frame_from = 100000
    local_min_in_scan_D = 20;   % optimal inter-channel delay, is read out from the matrix below
    local_min_in_scan_G = 20;   % read out from the matrix below
    end

    [y,Fs] = audioread(filename);
    disp(['wav-size: ', num2str(size(y))])
    %size(y)
    disp(['Fs = ', num2str(Fs)])
end

% -- do input wave plotting 1 --
chA = 1;
chB = 2;    % we are going to analyze the above 2 channels

figure(1)
title('whole signal')
subplot(211)
plot(y(:,chA))
subplot(212)
plot(y(:,chB))

seglen = 2048;

frame_till = frame_from + seglen+100;
disp(['frame_till = ', num2str(frame_till)])

% calculating one specific delay between channel 1 and channel 2
% for gain calculation, see the scanning matrices below:
% local_min_in_scan_G = 30;   % read out from the matrix below
gain_now = (local_min_in_scan_G-50)/60 + 1; % must be the same as in the loop below
% cutting the segs.
segs = y(frame_from:frame_till, :);

% applying (D)elay and (G)ain - to derive the one optimal frame:
% diff1 = segs(1:end-1, 1) - segs(2:end,2);
local_min_in_scan_D;
    from1 = 51;
    till1 = seglen+50;
    % --
    from2 = 1+local_min_in_scan_D;             % we are scanning +/- 50 samples, ie. (+/-50)/48k msecs ie. +/-35 cm.
    till2 = seglen+local_min_in_scan_D;
% local_min_in_scan_D = 0;   % optimal inter-channel delay, is read out from the matrix below

diff_D_frame = segs(from1:till1, chA) - gain_now.*segs(from2:till2,chB);;

% do  plotting of the selected (voiced) frame
figure(2)
title('selected frame')
subplot(311)
plot(segs(1:1000,chA))
title('channel A(1:1000)')
subplot(312)
plot(segs(1:1000,chB))
title('channel B(1:1000)')
subplot(313)
plot(diff_D_frame(1:1000))
title('chA(1:1000) - gain * delayed chB(1:1000)')


% scanning through different delay values between ch1 and ch2
% initializing the scanning matrices
seg_diff_matrix_D = zeros (seglen, 101);
seg_diff_matrix_G = zeros (seglen, 101);
signal_energy_over_D = zeros (101, 1);
signal_energy_over_G = zeros (101, 1);

for ii = 0:100
    % diff1 = segs(1:end-1, 1) - segs(2:end,2);
    from1 = 51;
    till1 = seglen+50;
    % --
    from2 = 1+ii;             % we are scanning +/- 50 samples, ie. (+/-50)/48k msecs ie. +/-35 cm.
    till2 = seglen+ii;
   
    % scanning through Delay
    % local_min_in_scan_G = 40; % this is read from a previous scan, but
    % already set above
    % optimalGainAtSample = 30
    gain_now = (local_min_in_scan_G-50)/60 + 1;
    diff_D = segs(from1:till1, chA) - gain_now.*segs(from2:till2,chB);
    
    % scanning through Gain
    gain_now = (ii-50)/60 + 1; % this scans through <0.2 ... 1.8>
    diff_G = segs(1:seglen, chA) - gain_now.*segs(1:seglen,chB);
    
    % writing the frame difference into scanning matrices
    seg_diff_matrix_D(1:seglen,ii+1) = diff_D;
    seg_diff_matrix_G(1:seglen,ii+1) = diff_G;

    % writing signal energies into a buffer, to see the optimel G and D.
    signal_energy_over_D(ii+1) = signalEnergy (diff_D);
    signal_energy_over_G(ii+1) = signalEnergy (diff_G);

end

% weighting the difference matrix
window = hamming (2048);            % should take into account the "2048-delay"
seg_diff_matrix_D = window .*seg_diff_matrix_D;

figure(3)
clf;
subplot(221)
imagesc (seg_diff_matrix_D)
title('Channel difference matrix- scanning through Delay')
xlabel('delay [samples]'); ylabel ('sample index [-]')
subplot(223)
plot(signal_energy_over_D); grid on
title('Diff frame energies through Delay')
xlabel('delay [samples]'); ylabel ('Frame energy [...]')

subplot(222)
imagesc (seg_diff_matrix_G)
title('Channel difference matrix- scanning through Gain')
xlabel('delay [samples]'); ylabel ('sample index [-]')
subplot(224)
plot(signal_energy_over_G); grid on
title('Diff frame energies through Gain')
xlabel('delay [samples]'); ylabel ('Frame energy [...]')


% calcul the spectrum of the joke
magn_spectr_D = spectrum_of_a_scan_oo1(seg_diff_matrix_D);

% check the 4 pre-defined frequency bands,how they perform.
[band1, band2, band3, band4] = marginalize_the_spectral_scan (magn_spectr_D);

% --- big image w the frame-differences and spectral differences --

if 1
    figure(4)
    clf;
    subplot(121)
    imagesc (seg_diff_matrix_D)
    title('Channel difference matrix- scanning through Delay')
    xlabel('delay [samples]'); ylabel ('sample index [-]')
    
    subplot(122)
    imagesc (magn_spectr_D)
    title('Channel difference SPECTRA - scanning through Delay')
    xlabel('delay [samples]'); ylabel ('8kHz ....... Freq bin index ......0kHz [-]')
    % some new stuff
    
end
%  eof.
