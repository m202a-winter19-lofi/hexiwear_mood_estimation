time = TIME(100:2252); % 1077 denotes t = 15 s
ppg = dark(100:2252);

calc_hrv
fft_ppg

SDNN_n = AMPD_SDNN;
HF_LF_n = HF_LF

time = TIME(1:1076);
ppg = chris_sad(1:1076);

calc_hrv
fft_ppg

comp_sdnn = AMPD_SDNN - SDNN_n;
if(comp_sdnn > 20)
    valence = 5;
elseif(comp_sdnn > 5)
    valence = 4;
elseif(comp_sdnn > -5)
    valence = 3;
elseif(comp_sdnn > -20)
    valence = 2;
else
    valence = 1;
end

comp_hf_lf = HF_LF/HF_LF_n;
if(comp_hf_lf > 5.0)
    arousal = 5;
elseif(comp_hf_lf > 1.5)
    arousal = 4;
elseif(comp_hf_lf > 0.9)
    arousal = 3;
elseif(comp_hf_lf > 0.7)
    arousal = 2;
else
    arousal = 1;
end

% if(AMPD_SDNN > SDNN_n) % pos valence
%     valence = 1
% else
%     valence = -1
% end
% if(HF_LF > HF_LF_n) % pos arousal
%     arousal = 1
% else
%     arousal = -1
% end