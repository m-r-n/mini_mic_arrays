
% ============================================================
% Main routine to analyze a DMA mic pair at different frequencies.
% Call: micPairResponse(micDist_mm() for calculating the attenuation
% A(f, d1, d2, DoA) as a function of (signal-frequency, mic-distances and DoA).
% -
% 1st version: 08.02.2024.
% 3rd ver.: 18.02.2024. changes:
% - color caption in freq scan plottings.not working
% - 2 mic dist used, separately as input for the micTriad script.
% - separate plotting of LF, (MF,) HF regions
% ============================================================


% -------------------------
% scanning through freqs:
% -------------------------

c = 343;         %   [m/sec]

% below DMA with a size of 80 mm (4 mics at 0, 15, 4ö, 80 mm)
mic_setup_0 = [15, 25, 40, 65, 80, 80, 80];

% below DMA with a size of 98 mm (mics at 0, 14, 14+28, 14+28+56mm ...)
mic_setup_1 = [14, 28, 42, 56, 84, 98, 140];

% below DMA with a size of 147 mm (mics at 0, 21, 21+42, 21+42+84mm, 21+42+84+21)
mic_setup_2 = [21, 42, 63, 84, 126, 147, 210];

mic_setup_chosen = mic_setup_2;

mic_spacing = mic_setup_chosen(1); 
display(['mic setup with ', num2str(mic_spacing),' spacing'])

% first 3 mics alone and in line
micDist1_mm = mic_setup_chosen(1)
micDist2_mm = mic_setup_chosen(2)
micDist3_mm = mic_setup_chosen(3)
micDist4_mm = mic_setup_chosen(4)
micDist5_mm = mic_setup_chosen(5)
micDist6_mm = mic_setup_chosen(6)
micDist7_mm = mic_setup_chosen(7)


% FREQ values we are scanning AT
f00 = 150;
f01 = 200;
f02 = 300;
f03 = 450;
f04 = 675;
f05 = 1000;

f06 = 1500;
f07 = 2000;
f08 = 3000;
f09 = 4500;
f10 = 6750;
f11 = 10000;

%delayFirstPair = micDist1 / c


% ---------------------------
% scanning through f1 ... f4% 
% ---------------------------

% do_plotting_in_soubroutine = 0

DPIS = 0 % plot ro no?


% -----------------
% TRIADES
% -----------------

% ---------------------------
% scanning through f1 ... f4% 
% ---------------------------

% do_plotting_in_soubroutine = 0

DPIS = 0 % plot OR no inside the micTriad ... routine?
plot_LF = 1;    % plot the LF part, below 1kHz
plot_HF = 1;    % plot the HF part, above 1kHz
plot_onePair = 0
plot_oneFreq = 0

% ---------------------------------------
% scanning through freqs, same mic setup:
% ---------------------------------------

if plot_onePair
    micDistoo1 = 112
    micDistoo2 = 56
    titleText = ['FIX Mic Triad, MicDist = ', num2str(150), '[mm] ',num2str(micDistoo1), '[mm], Freq = 200 ... 1000[Hz]' ]

    [angInRads, RR1] = micTriadResponse_002(1.5*micDistoo1, micDistoo1, 140, DPIS, 1);   %'red'
    [angInRads, RR2] = micTriadResponse_002(1.5*micDistoo1, micDistoo1, 200, DPIS, 1);   %'red'
    [angInRads, RR3] = micTriadResponse_002(1.5*micDistoo1, micDistoo1, 300, DPIS, 1);   %'green'
    [angInRads, RR4] = micTriadResponse_002(1.5*micDistoo1, micDistoo1, 450, DPIS, 1);   % 'bLue'
    [angInRads, RR5] = micTriadResponse_002(1.5*micDistoo2, micDistoo2, 670, DPIS, 1);   % 'Black
    [angInRads, RR6] = micTriadResponse_002(1.6*micDistoo2, micDistoo2, 1000, DPIS, 1);  % c
end

% ---------------------------------
% scanning mic params, const. freq:
% ---------------------------------

if plot_oneFreq

    micDistoo =112+56
    singlefreq = 200
    titleText = ['Stretched Mic Triad, MicDist = 1.75, 1.66, 1.50, 1.33, 1.25 x' ,num2str(micDistoo), '[mm], Freq =', num2str(singlefreq), '[Hz]' ]

    [angInRads, RR2] = micTriadResponse_002(1.75*micDistoo, micDistoo, singlefreq, DPIS, 1);   %'red'
    [angInRads, RR3] = micTriadResponse_002(1.66*micDistoo, micDistoo, singlefreq, DPIS, 1);   %'green'
    [angInRads, RR4] = micTriadResponse_002(1.5*micDistoo, micDistoo, singlefreq, DPIS, 1);   % 'bLue'
    [angInRads, RR5] = micTriadResponse_002(1.33*micDistoo, micDistoo, singlefreq, DPIS, 1);   % 'Black
    [angInRads, RR6] = micTriadResponse_002(1.25*micDistoo, micDistoo, singlefreq, DPIS, 1);  % c
end

% -----------------------------------------
% scanning through freqs, Final Mic Setup:
% -----------------------------------------
if plot_LF
    %                             Mic Dist: M1-M2 , M2-M3,  Hz, dPLOT, ... 
    [angInRads, RR1] = micTriadResponse_002(254,   168,     200, DPIS, 1);   %'yellow'
    [angInRads, RR2] = micTriadResponse_002(168,   112,    300, DPIS, 1);   %'red'
    [angInRads, RR3] = micTriadResponse_002(112,    84,    400, DPIS, 1);   %'green'
    [angInRads, RR4] = micTriadResponse_002(84,     56,     600, DPIS, 1);   % 'bLue'
    [angInRads, RR5] = micTriadResponse_002(56,     42,     800, DPIS, 1);   % 'Black
    [angInRads, RR6] = micTriadResponse_002(42,     21,    1200, DPIS, 1);  % cyan
end

if plot_HF

    titleText = ['Multi-Mic Triads, MicDist = 7, 14, 28, 42, 56, 84, 112, 168[mm], Freq = 200 ... 6000[Hz]' ]


    [angInRads, RR7] = micTriadResponse_002(28, 21,  1600, DPIS, 1);    %r--'
    [angInRads, RR8] = micTriadResponse_002(21, 14, 2400, DPIS, 1);    % g-- OK
    [angInRads, RR9] = micTriadResponse_002(14, 10,  3200, DPIS, 1);    % b--
    [angInRads, RR10] = micTriadResponse_002(10, 7, 4800, DPIS, 1);   % Black
    [angInRads, RR11] = micTriadResponse_002(7, 4,  6400, DPIS, 1);   % C--
    %[angInRads, RR12] = micTriadResponse_002(14, 7, 9600, DPIS, 1);  % Y-- OK
end



% -----------------
% PLOTTING - Polar
% -----------------

figure(141); clf; 

shift_in_dB = 50;

if (plot_LF | plot_onePair | plot_oneFreq)
    polarplot(RR1 + shift_in_dB, 'y'); hold on
    polarplot(RR2 + shift_in_dB, 'r'); hold on
    polarplot(RR3 + shift_in_dB, 'g'); hold on
    polarplot(RR4 + shift_in_dB, 'b'); hold on
    polarplot(RR5 + shift_in_dB, 'k')
    polarplot(RR6 + shift_in_dB, 'c')
end

if plot_HF
    polarplot(RR7 + shift_in_dB, 'r-.'); hold on
    polarplot(RR8 + shift_in_dB, 'g-.')
    polarplot(RR9 + shift_in_dB, 'b-.')
    polarplot(RR10 + shift_in_dB,'k-.');
    polarplot(RR11 + shift_in_dB,'c-.')
    %polarplot(RR12 + shift_in_dB,'y-.')
end

title (titleText)
%title(['mic setup with ', num2str(mic_spacing),' spacing'])


% -----------------------
% PLOTTING - Linear Freq.
% -----------------------

figure(151); clf; 

shift_in_dB = 60;

if (plot_LF | plot_onePair | plot_oneFreq)
    plot(RR1 + shift_in_dB, 'y'); hold on
    plot(RR2 + shift_in_dB, 'r'); hold on
    plot(RR3 + shift_in_dB, 'g'); hold on
    plot(RR4 + shift_in_dB, 'b') ; hold on
    plot(RR5 + shift_in_dB, 'k')
    plot(RR6 + shift_in_dB, 'c')
end
if plot_HF
    plot(RR7 + shift_in_dB, 'r-.'); hold on
    plot(RR8 + shift_in_dB, 'g-.')
    plot(RR9 + shift_in_dB, 'b-.')
    plot(RR10 + shift_in_dB,'k-.');
    plot(RR11 + shift_in_dB,'c-.')
    %plot(RR12 + shift_in_dB, 'y-.')
end

title (titleText)
xlabel('DoA [deg]')
ylabel('Attn [dB]')


grid on