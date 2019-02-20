function  MouseDraw(action)
%以Handle Graphics来设定滑鼠事件
%鼠标左键按下不放进行写字，右键进行识别
%(MouseDraw Events)的反应指令(Callbacks)
% global不能传矩阵
 global InitialX InitialY FigHandle 
 imSizex = 90;  %定义图片的长度
 imSizey = 120; %定义图片的宽度
 if nargin == 0
     action = 'start';   
 end
 switch(action)
    %%开启图形视窗
    case 'start',
        FigHandle = figure('WindowButtonDownFcn','MouseDraw down');
        set(FigHandle,'position',[200,200,360,410] ); %设定图窗大小来适应识别的图片大小
        %set(gca,'position',[0.1,0.1,0.5,0.8] ); %定
        axis([1 imSizex 1 imSizey]);    % 设定图轴范围
        grid on;
        box on;     % 将图轴加上图框
        title('手写体输入窗(左键写字 右键识别)');
        dlmwrite('C:\Users\Hubery\Desktop\大三课程\人工智能\大作业\GUI2\IXT.txt', -10, 'delimiter', '\t', 'precision', 6);
        dlmwrite('C:\Users\Hubery\Desktop\大三课程\人工智能\大作业\GUI2\IYT.txt', -10, 'delimiter', '\t', 'precision', 6);
        %%滑鼠按钮被按下时的反应指令
    case 'down',
        if strcmp(get(FigHandle, 'SelectionType'), 'normal')    %如果是左键
            set(FigHandle,'pointer','hand');      
            CurPiont = get(gca, 'CurrentPoint');
            InitialX = CurPiont(1,1);
            InitialY = CurPiont(1,2);
            dlmwrite('C:\Users\Hubery\Desktop\大三课程\人工智能\大作业\GUI2\IXT.txt', InitialX, '-append', 'delimiter', '\t', 'precision', 6);
            dlmwrite('C:\Users\Hubery\Desktop\大三课程\人工智能\大作业\GUI2\IYT.txt', InitialY, '-append', 'delimiter', '\t', 'precision', 6);
            set(gcf, 'WindowButtonMotionFcn', 'MouseDraw move');
            set(gcf, 'WindowButtonUpFcn', 'MouseDraw up');
        elseif strcmp(get(FigHandle, 'SelectionType'), 'alt')   % 如果是右键
            set(FigHandle, 'Pointer', 'arrow');
            set( FigHandle, 'WindowButtonMotionFcn', '')
            set(FigHandle, 'WindowButtonUpFcn', '')
            fprintf('MouseDraw right button down!\n');
            ImageX = importdata('C:\Users\Hubery\Desktop\大三课程\人工智能\大作业\GUI2\IXT.txt');
            ImageY = importdata('C:\Users\Hubery\Desktop\大三课程\人工智能\大作业\GUI2\IYT.txt');
            InputImage = ones(imSizex,imSizey);
            roundX = round(ImageX);
            roundY = round(ImageY);
            for k = 1:size(ImageX,1)
                if 0<roundX(k) && roundX(k)<imSizex && 0<roundY(k) && roundY(k)<imSizey
                    InputImage(roundX(k)-1:roundX(k)+2, roundY(k)-1:roundY(k)+2) = 0;
                end
            end
            InputImage = imrotate(InputImage,90);       % 图像旋转90
            axes(FigHandle.Children),cla;%删除坐标图像
            delete('C:\Users\Hubery\Desktop\大三课程\人工智能\大作业\GUI2\IXT.txt');%每次识别完要先删除，否则是根据上面的'-append'写入
            delete('C:\Users\Hubery\Desktop\大三课程\人工智能\大作业\GUI2\IYT.txt');
            bayesBinaryTest(InputImage); %调用手写体识别函数
            imwrite(InputImage,'C:\Users\Hubery\Desktop\大三课程\人工智能\大作业\GUI2\图片.bmp');
        end
    %%滑鼠移动时的反应指令
    case 'move',
        CurPiont = get(gca, 'CurrentPoint');
        X = CurPiont(1,1);
        Y = CurPiont(1,2);
        % 当鼠标移动较快时，不会出现离散点。
        % 利用y=kx+b直线方程实现。
        x_gap = 0.1;    % 定义x方向增量
        y_gap = 0.1;    % 定义y方向增量
        if X > InitialX
            step_x = x_gap;
        else
            step_x = -x_gap;
        end
        if Y > InitialY
            step_y = y_gap;
        else
            step_y = -y_gap;
        end  
        % 定义x,y的变化范围和步长
        if abs(X-InitialX) < 0.01        % 线平行于y轴，即斜率不存在时
            iy = InitialY:step_y:Y;
            ix = X.*ones(1,size(iy,2));
        else
            ix = InitialX:step_x:X ;    % 定义x的变化范围和步长
            % 当斜率存在，即k = (Y-InitialY)/(X-InitialX) ~= 0
            iy = (Y-InitialY)/(X-InitialX).*(ix-InitialX)+InitialY;   
        end
        ImageX = [ix, X]; 
        ImageY = cat(2, iy, Y);
        line(ImageX,ImageY, 'marker', '.', 'markerSize',18, ...
            'LineStyle', '-', 'LineWidth', 2, 'Color', 'Black');
        dlmwrite('C:\Users\Hubery\Desktop\大三课程\人工智能\大作业\GUI2\IXT.txt', ImageX, '-append', 'delimiter', '\t', 'precision', 6);
        dlmwrite('C:\Users\Hubery\Desktop\大三课程\人工智能\大作业\GUI2\IYT.txt', ImageY, '-append', 'delimiter', '\t', 'precision', 6);
        InitialX = X;       %记住当前点坐标
        InitialY = Y;       %记住当前点坐标
    %%滑鼠按钮被释放时的反应指令
    case 'up',
        % 清除滑鼠移动时的反应指令
        set(gcf, 'WindowButtonMotionFcn', '');
        % 清除滑鼠按钮被释放时的反应指令
        set(gcf, 'WindowButtonUpFcn', '');
end
