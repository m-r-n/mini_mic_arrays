function [angInRads, AttnVector] = micTriadResponse_002(micDist1_mm, micDist2_mm, freq_Hz, do_plotting, do_triad)

% ============================================================
% printing Attenuation curves of a DMA mic pair, or triad,
% as a function of (signal-frequency, mic-distance and DoA).
% necessary input parameter is microphone distance in [mm]
% 1st version: 08.02.2024.
% -- input params: --
% micDist1_mm ... distance between M1 and M2    [mm]
% micDist2_mm ... distance between M2 and M3    [mm]
% freq_Hz ....... scanning 0..360° at this freq [Hz]
% do_plotting ... do plotting inside this routine (yes == 1)
% do_triad ...... do also include the effect of M3
% ============================================================

% do_plotting = 1;
% micDist_mm = 21;
% freq_Hz = 5000
 
c = 343;
Fs = 48000;

cutAtAttn = -50;    % cut at minus 50dB

% 1st to third mic distance = 150% of first to second mic dist
% Example1: micDist1_mm = 63 (3x21) vs micDist2_mm = 42mm (2x21)
% Example2: micDist1_mm = 42 (3x14) vs micDist2_mm = 28mm (2x14)


micDist1_mm
micDist2_mm
% the prev version ohad only the prev. input
% micDist2_mm = 1.5 * micDist1_mm

%zeroPosition2 = micDist1_mm /2


 micDist1 = micDist1_mm / 1000; % [m]
 micDelay1 = micDist1 / c;
 micDelayInSamples1 = micDelay1 * Fs

 micDist2 = micDist2_mm / 1000; % [m]
 micDelay2 = micDist2 / c;
 micDelayInSamples2 = micDelay2 * Fs

 % this is the 2nd NULL point we are simulating with M3
 zeroPosition2 =  micDelayInSamples1


 if do_plotting
     disp(['micDist: ' , num2str(micDist), '[m]'])
     disp(['micDelayInSamples: ' , num2str(micDelayInSamples), '[samples]'])
 end

% -- time axis --

samplingDelay = 1/Fs;
t = 0:1:Fs;
t = t./Fs;
frameLen = 1024;

% -- generate signal composed ofone harmonic --

%freqHz = xxx
s1 = sin(2*pi * freq_Hz * t);

% -- scanning through 360degs --

angInDegs = 1:360;
angInRads = angInDegs/180*pi;

% test:
cos(angInRads(1));
cos(angInRads(90));
cos(angInRads(180));

%delays = cos(angInRads) .* micDelay1;
delaysInSamples1 = cos(angInRads) .* micDelayInSamples1;
delaysInSamplesFixed1 = round (delaysInSamples1);

%delays = cos(angInRads) .* micDelay1;
delaysInSamples2 = cos(angInRads) .* micDelayInSamples2;
delaysInSamplesFixed2 = round (delaysInSamples2);


if do_plotting
    figure(2)
    subplot(211); plot(angInDegs, delays); grid on
    xlabel('angle-of-arrival'); ylabel('delay in Sec')
    
    subplot(212); 
    plot(angInDegs, delaysInSamples,'r'); hold on
    plot(delaysInSamplesFixed1,'b'); grid on
    xlabel('angle-of-arrival'); ylabel('delay in Samples')
end;

% ------------------------------------------
% MAIN LOOP: 0-360 degs, stepping through
% ------------------------------------------

AttnVector = zeros(1,360);

for ii = 1:360;
    % shifting one channel acc to the delaysInSamples
    DoA = angInDegs(ii); 
    dd = delaysInSamples1(DoA);

    % shifting the THIRD channel acc to the delaysInSamples
    DoA = angInDegs(ii); 
    dd2 = delaysInSamples2(DoA);
    %dd2 = dd2 +24; % adding a Null point to arcCos(1/3), if micDist = 3 samples in space
    dd2 = dd2 + zeroPosition2; 

    
    %dd= 50;          % simulated delay
    offset1= 200;   % starting to analyze the signal after this offset
    DoA_delay = 0;
    
    
    % ------------------------------------
    %  Response of 1st and 2nd Mic:
    % ------------------------------------

    % simulatd signal of mic 1:
    from = offset1 + DoA_delay;
    till = offset1 + DoA_delay + frameLen ;
    sm1 = s1(from:till);
    
    % simulatd signal of mic 2, linearly interpolated:
    dd_U = ceil(dd);
    weight_U = dd - (floor(dd));
    from = offset1 + dd_U;
    till = offset1 + dd_U + frameLen;
    sm2_U = weight_U.* s1(from:till);          % upper samples, linearly weighted

    dd_L = floor(dd);
    weight_L = 1 - weight_U;
    from = offset1 + dd_L;
    till = offset1 + dd_L + frameLen;
    sm2_L = weight_L.* s1(from:till);          % lower samples, linearly weighted
    
    sm2 = sm2_L + sm2_U;
    
    % simulated signal difference :
   
    smD = sm2 - sm1;

    % ------------------------------------
    %   Adding the effect of the 3rd Mic:
    % ------------------------------------

    if do_triad
        % simulatd signal of mic 3, linearly interpolated:
        dd_U = ceil(dd2);
        weight_U = dd2 - (floor(dd2));
        from = offset1 + dd_U;
        till = offset1 + dd_U + frameLen;
        sm3_U = weight_U.* s1(from:till);          % upper samples, linearly weighted
    
        dd_L = floor(dd2);
        weight_L = 1 - weight_U;
        from = offset1 + dd_L;
        till = offset1 + dd_L + frameLen;
        sm3_L = weight_L.* s1(from:till);          % lower samples, linearly weighted
    
        sm3 = sm3_L + sm3_U;
        
        % simulated signal difference
        smD = smD - 0.5 .*sm3; % this is the final with 3 mics (see 10 lines above, too)
        %smD = sm1-sm3;  % this is only using the 1st and third channel

    end % of do_triad


    % ------------------------------------
    %  Calculating the ATTN in compar M1
    % ------------------------------------

    % simulated signal energies:
    sm1_SE = signalEnergy(sm1);
    sm2_SE = signalEnergy(sm2);
    smD_SE = signalEnergy(smD);
    
    Attn1 = 10*log(smD_SE / (sm2_SE + 0.001) );

    AttnVector(ii) = Attn1;


end; % of ii

% ------------------------------------------
% MAIN LOOP: PLOTTING
% ------------------------------------------

% cutting AttnVector at -100dB:
AttnVector(AttnVector < cutAtAttn) = cutAtAttn;
if do_plotting

    disp(['min Attn: ', num2str(min(AttnVector))])
    disp(['max Attn: ', num2str(max(AttnVector))])
end;


if do_plotting
    figure(4); clf;
    polarplot(AttnVector + 60); % this is the cut_attn like variable
    %hold on;
    grid on
    title (['Mic Pair Response, MicDist = ', num2str(micDist1_mm), '[mm], Freq = ',num2str(freq_Hz),'[Hz]' ])
    %xlabel('DoA [deg]')
    %ylabel('Attn [dB]')
end;

%disp('entering Debugging, ie. keyboard mode, ... to return type DBCONT.')
%keyboard
%hold on


