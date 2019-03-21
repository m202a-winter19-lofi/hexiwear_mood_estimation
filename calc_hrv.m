% getting size of samples
dummy = size(ppg);
num_samples = dummy(1);

% moving average
movave = zeros(num_samples,1);
avecap = 25;
for i = 1:(avecap-1)/2
    for j = 1:i+(avecap-1)/2
        movave(i) = movave(i) + ppg(j);
    end
    movave(i) = movave(i)/(i+(avecap-1)/2);
end
for i = (num_samples-(avecap-1)/2+1):num_samples
    for j = i-(avecap-1)/2:num_samples
        movave(i) = movave(i) + ppg(j);
    end
    movave(i) = movave(i)/(num_samples-i+(avecap-1)/2+1);
end
for i = (avecap-1)/2+1:(num_samples-(avecap-1)/2)
    for j = i-(avecap-1)/2:i+(avecap-1)/2
        movave(i) = movave(i) + ppg(j);
    end
    movave(i) = movave(i)/avecap;
end
ppg = ppg-movave; % normalize ppg

% smoothing curve
for i = 2:num_samples
    ppg(i) = ppg(i) + ppg(i-1);
end

% AMPD Algorithm
kcap = 25;
m = zeros(kcap, num_samples);
for k = 1:kcap
    for i = 1:num_samples
        if(i-1 < 1 || i-k-1 < 1 || i+k-1 > num_samples)
            m(k,i) = 0;
        elseif(ppg(i-1)>ppg(i-k-1) && ppg(i-1)>ppg(i+k-1))
            m(k,i) = 1;
        else
            m(k,i) = 0;
        end
    end
end
max_mult = m(1,:)';
for k = 2:kcap
   max_mult = max_mult .* m(k,:)';
end

% extract times that are max
num_max = sum(max_mult);
time_of_max = zeros(num_max, 1);
index_of_max = zeros(num_max, 1);
max_points = zeros(num_max, 1);
j = 1;
for i = 1:num_samples
    if(max_mult(i) == 1)
        time_of_max(j) = time(i-1);
        index_of_max(j) = i-1;
        max_points(j) = ppg(i-1);
        j = j+1;
    end
end

% calculating HRV
r = zeros(num_max-1, 1);
index_r = zeros(num_max-1, 1);
for i = 1:num_max-1
    r(i) = time_of_max(i+1)-time_of_max(i);
    index_r(i) = index_of_max(i+1)-index_of_max(i);
end

% getting rid of outlier points in r
mean_inter_time = mean(r);
for i = 1:num_max-1
    if r(i) > mean_inter_time + 0.11
        r(i) = mean_inter_time + 0.11;
    elseif r(i) < mean_inter_time - 0.11
        r(i) = mean_inter_time - 0.11;
    end
end

% SDNN -- stand dev of normal to normal R-R intervals
mean_inter_time = mean(r);
AMPD_SDNN = 0;
for i = 1:num_max-1
    AMPD_SDNN = AMPD_SDNN + (r(i)-mean_inter_time)^2;
end
AMPD_SDNN = sqrt(AMPD_SDNN/(num_max-1))*1000; % units ms

% % RMSSD -- RMS diff of successive R-R intervals
% AMPD_RMSDD = 0;
% for i = 2:num_max-1
%     AMPD_RMSDD = AMPD_RMSDD + (r(i)-r(i-1))^2;
% end
% AMPD_RMSDD = sqrt(AMPD_RMSDD/(num_max-2))*1000 % units ms