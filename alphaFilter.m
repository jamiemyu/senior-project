function Hd = alphaFilter(Fs)
% Specify a passband from 8-13 Hz.
Wp = [8 13]/(Fs/2);

% Set the stopband width to 0.5 Hz on both sides of the passband.
Ws = [7.5 13.5]/(Fs/2);

% Specify max 3 dB passband ripple, min 40 dB attenuation in stopbands.
Rp = 3;
Rs = 40;

[n, Wn] = buttord(Wp, Ws, Rp, Rs);
[z, p, k] = butter(n, Wn, 'bandpass');
[sos, g] = zp2sos(z, p, k);
Hd = dfilt.df2sos(sos, g);
end