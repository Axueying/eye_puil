%这个程序是有视频播放的；
clc; clear;
path = 'H:\eye_move\program4_0_move\';
name = 'Z63 2019_5_8 221057'
v = VideoReader([path, name, '.avi']);
path1 = 'H:\eye_move\program4_0_move\'
name1 = 'Z63';
% name2= 'eZ73';          %原始的眼动图；
origin_row = 1;            %只有圆心和0度两个点的情况，下标是从0开始的；
feature_num = 2;
filename = [name1 '.csv'];
eye = xlsread([path1, filename]);                   %导入瞳孔的坐标x,y;

for i = origin_row:1:length(eye)
    for j = 2;
        if((eye(i,4)>0.8)&&eye(i,3*j+1)>0.8)                     %概率（圆心和0读的概率都非常高）
            p1 = [eye(i,2),eye(i,3)];
            p2 = [eye(i,3*j-1),eye(i,3*j)];
            eye_puils(i-origin_row+1,j-1) = norm(p1-p2);                %二范数就是平方和再开方
            circle(i-origin_row+1,j-1) = {p1};
        else
            eye_puils(i-origin_row+1,j-1) = eye_puils(i-origin_row,j-1);                %二范数就是平方和再开方
            circle(i-origin_row+1,j-1) = circle(i-origin_row,j-1);
        end
    end
end
eye_sum = sum(eye_puils,2);
eye_ave = eye_sum/(feature_num-1);
% eye_normli = normalize1(eye_ave);
eye_normli = eye_ave./127;
[eye_smooth, winwidth] = adapt_smooth(eye_normli, 'gauss', 400, .00003);

frame = v.FrameRate;
zhen_total = length(eye_ave);
figure
% myMovie = read(v,[1:zhen_total]);
x = (1:1:length(eye_ave))/200.0;


for i = 1:30:zhen_total
    %     clf;
    figure(1);
    subplot(1,2,1);
    imshow(read(v,[i]));
    hold on;
    rectangle('Position',[circle{i}(1)-eye_ave(i),circle{i}(2)-eye_ave(i),2*eye_ave(i),2*eye_ave(i)],'Curvature',[1,1],'linewidth',2,'EdgeColor','r'),axis equal
    drawnow;
    hold off;
    %     figure (2);
    subplot(1,2,2);
    if i<zhen_total-100
        plot(x(i:i+100),eye_smooth(i:i+100),'b');
        axis([x(i)-2 x(i)+2 0 0.5])
%         ylim([0 0.5]);
        drawnow;
        
        hold on;
    else
        plot(x(i:end),eye_smooth(i:end),'b');
        axis([x(i)-2 x(i)+2 0 0.5])
%         ylim([0 0.5])
        drawnow;
        
        hold on;
    end
    
end




