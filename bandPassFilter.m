function Hd = bandPassFilter(Fs, passBand)
% Passband is loaded from function input
Wp = passBand / (Fs/2);

% Set the stopband width on both sides of the passband.
Ws = [(passBand(1) - 0.3), (passBand(2) + 2)] / (Fs/2);

% Specify max 3 dB passband ripple, min 40 dB attenuation in stopbands.
Rp = 3;
Rs = 40;

[n, Wn] = buttord(Wp, Ws, Rp, Rs);
[z, p, k] = butter(n, Wn, 'bandpass');
[sos, g] = zp2sos(z, p, k);
Hd = dfilt.df2sos(sos, g);
end