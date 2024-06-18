function [magn_spectr] = spectrum_of_a_scan_oo1 (seg_diff_matrix_D)

% used in "dma_oo1.m"
% input: seg_diff_matrix_D
% output: the magnitude spectrum of each vertical frame

[Ym, Xm] = size(seg_diff_matrix_D);

% initialize the output matrix
% originally we were calculating it till Nyquit Freq:
% Ymax_of_spectr = Ym/2+1; (2048/2 +1 )
% However, we are interested only till 10.24kHz:

Ymax_of_spectr = 683 ;%Ym/3; % ie. 48000/2/3(Fs)(NFFt)
magn_spectr = zeros (Ymax_of_spectr, Xm);

for xx = 1:Xm
    % extract a segment
    segment = seg_diff_matrix_D(:, xx);

    % magn spectrum of a segment
    seg_spec = 10*log (abs(fft (segment))+0.0001);

    % store into the output matrix
    magn_spectr(:, xx) = seg_spec(1:Ymax_of_spectr);
end

