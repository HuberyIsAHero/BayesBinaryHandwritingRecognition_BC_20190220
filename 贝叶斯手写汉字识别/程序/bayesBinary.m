function y = bayesBinary(sample)
%基于概率统计的贝叶斯分类器
%sample为要识别的图片的特征(1列100行的概率)
clc;    %清屏
load templet pattern;   %加载汉字特征
sum = 0;                %初始化sum
prior = [];             %先验概率
p = [];                 %各类别代表点
likelihood = [];        %类条件概率
pwx = [];               %贝叶斯概率
%%计算先验概率
for i=1:9
    sum = sum+pattern(i).num; %特征总数
end
for i=1:9
    prior(i) = pattern(i).num/sum;  %出现每个汉字的可能性(先验概率)
end
%%计算类条件概率
for i=1:9   %9个汉字
    for j=1:100 %100个模块
        sum = 0;
        for k=1:pattern(i).num %特征数
            if(pattern(i).feature(j,k)>0.05)  %概率大于阈值0.05则数量+1
                sum = sum+1;
            end 
        end
        p(j,i) = (sum+1)/(pattern(i).num+2);%计算概率估计值即Pj(ωi)，注意拉普拉斯平滑处理
    end
end
for i=1:9
    sum = 1;
    for j=1:100
        if(sample(j)>0.05)
            sum = sum*p(j,i);%如果待测图片当前概率大于0.05认为特征值为1，直接乘Pj(ωi)
        else
            sum = sum*(1-p(j,i));%如果待测图片当前概率小于0.05认为特征值为0，乘(1-Pj(ωi))
        end
    end
    likelihood(i) = sum;  %将类条件概率赋值给likelihood
end
%%计算后验概率
sum = 0;
for i=1:9
    sum = sum+prior(i)*likelihood(i);  %求和即得P(X)
end
for i=1:9
    pwx(i) = prior(i)*likelihood(i)/sum;  %贝叶斯公式
end
[maxval maxpos] = max(pwx);   %计算最大值和其所在位置
y=maxpos;                     %返回类的下标即汉字的类号

