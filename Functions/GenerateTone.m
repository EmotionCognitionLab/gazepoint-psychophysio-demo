function [y,Fs] = GenerateTone(tone_type,tone_freq,tone_dur,ear,Fs)

% Set up the audio wave
Ts = 1/Fs;
T = [0:Ts:tone_dur]';

looming_multiplier = [0:1/numel(T):1-1/numel(T)]';  %weighting to create looming effect
click_eliminator = [0:1/200:1 ones(1,numel(T)-402) flip(0:1/200:1)]'; %weighting to eliminate edge clicking

y = sin(2*pi*tone_freq*T);  %sinuoisodal wave form for given frequency


% Process tones
y = y.*click_eliminator;        % remove edge clicks

switch lower(tone_type)
    case 'constant'
        % no need to multiply waveform
    case 'looming'
        y = looming_multiplier.*y;
    case 'receding'
        y = flip(looming_multiplier).*y;
end
switch lower(ear)
    case 'both'
        % leave y alone
    case 'left'
        % append an empty right channel
        y = [y zeros(length(y),1)];
    case 'right'
        % append an empty left channel
        y = [zeros(length(y),1) y];
end

end
