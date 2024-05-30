
function SE = signalEnergy (signal);

% ==
% summing squared samples
% ==

L= length(signal);

SE = 0;
for i=1:L
    SS=(signal(i) * signal(i));
    SE = SE + SS;
end

