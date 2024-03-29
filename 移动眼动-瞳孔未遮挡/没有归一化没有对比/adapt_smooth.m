function [sdata, winwidth] = adapt_smooth(data, type, winwidth_max, err_crit)
%使用方法： [sangle, winwidth] = adapt_smooth(angle, 'gauss', winwidth_max,
%.00003); 1~2倍的采样率
success = 0;
ce(1) = sqrt(mean(diff(data).^2)/2);

iterL = 0:4:winwidth_max;
if length(iterL) < 2
    iterL = [0, 2];
end

for i = 2:length(iterL)

    winwidth = iterL(i);
    sdata = smooth(data, winwidth, type);
    scd = diff(sdata);
    ce(i) = sqrt(mean(scd.^2)/2);  %conductance_error

        if abs(ce(i) - ce(i-1)) < err_crit
            success = 1;
            break;
        end

end

if success  %take before-last result
    
    if i > 2
        sdata = smooth(data, iterL(i-1), type);
        winwidth = iterL(i-1);
    else %data already satisfy smoothness criteria
        sdata = data;
        winwidth = 0;
    end
    
end
