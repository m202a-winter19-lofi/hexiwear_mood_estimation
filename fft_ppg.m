% facts = [1 2 3 4 5 6 7 8 9 10 11];
% for i = 2:11
%     facts(i) = facts(i)*facts(i-1);
% end
% 
% cos_mine = @(x) 1 - x^2/facts(2) + x^4/facts(4) - x^6/facts(6) + x^8/facts(8) - x^10/facts(10);
% sin_mine = @(x) x - x^3/facts(3) + x^5/facts(5) - x^7/facts(7) + x^9/facts(9) - x^11/facts(11);

% need num_samples and ppg

fftppg = zeros(num_samples,1);

for i = 1:num_samples
    real = 0;
    im = 0;
    for j = 1:num_samples
        real = real + ppg(j)*cos(2*pi*(j-1)*(i-1)/num_samples);
        im = im + ppg(j)*sin(2*pi*(j-1)*(i-1)/num_samples);
%         real = real + ppg(j)*cos_mine(2*pi*(j-1)*(i-1)/num_samples);
%         im = im + ppg(j)*sin_mine(2*pi*(j-1)*(i-1)/num_samples);
    end
    fftppg(i) = sqrt(real^2 + im^2)/num_samples;
end

% P1(2:floor(num_samples/2)) = 2*P1(2:floor(num_samples/2));
% f = 1/TIME(2)*(0:floor(num_samples/2))/num_samples;
f = 1/TIME(2)*(0:num_samples-1)/num_samples;

% figure;
% plot(f(1:40),fftppg(1:40));
% title('Zoomed in Fast Fourier Transform of PPG Signal');
% xlabel('f (Hz)');
% ylabel('FFT of PPG Signal');

LF = 0;
i = 1;
while f(i) < 0.15
    LF = LF + fftppg(i);
    i = i + 1;
end

HF = 0;
while f(i) < 0.4
    HF = HF + fftppg(i);
    i = i + 1;
end
HF_LF = HF/LF;