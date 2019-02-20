function sampleTraining(cla,fea,dataSet)
%学习单个样本特征
%cla表示第几个类即汉字个数,fea表示第几个特征即特征向量,dataSet为学习的字符集
%每个样本图片被分成10*10=100个cell
%需要注意图片的的长和宽都需被定义成10的倍数,因为后面要被10除
clc;            %清屏
load templet pattern;   %加载汉字特征
A=imread(['C:\Users\Hubery\Desktop\File\Hubery\大作业\测试\样本集\',dataSet(cla),num2str(fea),'.bmp']);
figure(1),imshow(A) %显示读取的手写灰度图
B=zeros(1,100);     %创建1列100行的数组
pattern(cla).feature(:,fea)=zeros(100,1); %初始化当前类的第fea个初始化特征向量
[row col] = size(A); %获取样本图片的行列
cellRow = row/10;    %除以10得到1/100的小个子
cellCol = col/10;
count = 0;           %每1/100个格子中为0的像素点个数
currentCell = 1;     %当前计算为第1个1/100格子部分
for currentRow = 0:9
    for currentCol = 0:9
       for i = 1:cellRow      %计算每1/100部分中为0的数量
           for j = 1:cellCol
               if(A(currentRow*cellRow+i,currentCol*cellCol+j)==0)
                   count=count+1;
               end
           end
        end
        ratio = count/(cellRow*cellCol); %计算1/100部分中黑色像素的占比
        B(1,currentCell) = ratio;        %将每个占比统计在B特征向量中
        currentCell = currentCell+1;     %新的1/100部分开始计算
        count = 0;                       %像素点计数置0
     end
end
pattern(cla).num=5;             %类的特征数量(feature中的列数)
pattern(cla).name=dataSet(cla); %当前类代表的汉字字符
pattern(cla).feature(:,fea)=B'; %当前类第fea列特征向量
save templet pattern            %保存学习样本的汉字特征
%                
            
