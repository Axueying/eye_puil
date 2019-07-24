%Author yulou.zhang
%方法一： 求取半径的平均值(对于只标记0度和圆心);做平滑处理，没有归一化，没有对比文件；
clc;clear;
path = 'H:\eye_move\program4_0_move\'
name = '026 2019_5_28 210518labeled';
origin_row = 1;            %只有圆心和0度两个点的情况，下标是从0开始的；
feature_num = 2;
filename = [name '.csv'];
eye = xlsread([path, filename]);                   %导入瞳孔的坐标x,y;

for i = origin_row:1:length(eye)
    for j = 2
       if((eye(i,4)>0.8)&&eye(i,3*j+1)>0.8)                     %概率（圆心和0读的概率都非常高）
            p1 = [eye(i,2),eye(i,3)];
            p2 = [eye(i,3*j-1),eye(i,3*j)];    
            eye_puils(i-origin_row+1,j-1) = norm(p1-p2);                %二范数就是平方和再开方
       else
           if i == 1
               eye_puils(1,1)= 0;
               
           else
               eye_puils(i-origin_row+1,j-1) = eye_puils(i-origin_row,j-1);                %二范数就是平方和再开方
           end
           
       end
    end
end      
eye_sum = sum(eye_puils,2);
eye_ave = eye_sum/(feature_num-1);
% eye_ave = eye_sum;
% find(eye_ave>60);                          %数据处理
% eye_ave(find(eye_ave>60))=[];             %数据处理

% method1
%%eye_normli = normalize1(eye_ave);
% [eye_smooth, winwidth] = adapt_smooth(eye_normli, 'gauss', 400, .00003);
% eye_smooth1 = eye_smooth./(max(max(eye_smooth))*2);
x = (1:1:length(eye_ave))/200.0;

% test_eye = load([path name1]);
% 
% test_eye_normali = normalize1(test_eye(:,4));         %储存瞳孔直径的那一列；
% [test_eye_smooth, winwidth] = adapt_smooth(test_eye_normali, 'gauss', 400, .00003);
% test_eye_smooth1 = test_eye_smooth./(max(max(test_eye_smooth))*2);

fig = figure;
set(fig, 'Position', [50 700 1200 200]);
% plot(x,test_eye_normali,'r');

% ylim([0 1]);
title('Pupil diameter method1_2','FontName','Times New Roman','Color','b');
hold on;
a1=find(eye_ave>60)
eye_ave(find(eye_ave>60))=[];  
x(a1)=[];
[eye_smooth, winwidth] = adapt_smooth(eye_ave, 'gauss', 400, .00003);
plot(x,eye_smooth./127,'b');
ylim([0 0.5]);
set(gca,'YTick',[0:0.1:0.5],'FontSize',10);
box off;
xlabel('Time');
ylabel('original data /mm');
legend('original data','processed data','Location','northeast');
