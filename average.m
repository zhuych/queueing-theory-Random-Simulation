function averagewaittime = average( n,lamda,c,k,transporttime,mu)
%   n个产品(注意,n应为k的整数倍),到达服从参数lamda的泊松流;
%   c个配送员;一次派送k个;服务时间由运输时间transporttime及楼下等待时间组成
%   楼下等待时间服从参数为mu的k阶爱尔朗分布
inflow=exprnd(1/lamda,n,1);  
for i=1:n
    arrivetime(i)=inflow(i);  %产品剩余到达时间
    state(i)=0;   %顾客状态为未到达
end
courier(1)=1;
for j=1:c
    courier(j)=1; %空闲
    servicetime(j)=0;  %各配送员剩余服务时间
end
queue=0;    %队长
time=0;  %模拟时间轴
eventtime=arrivetime(1);
first=1;  %等待队列中第一个顾客编号
i=1;
while (state(n)~=-1)
    time=time+eventtime;   %可记录event状态，改进计算速度
    %状态更新
    if (i<=n)
    arrivetime(i)=arrivetime(i)-eventtime;
    if (arrivetime(i)==0)
        state(i)=1;   %顾客进入队列
        queue=queue+1;
        i=i+1;
    end
    end
    for j=1:c
        if (courier(j)==0)
            servicetime(j)=servicetime(j)-eventtime;
            if (servicetime(j)==0)
                courier(j)=1;
            end
        end
    end
    spare=1;  %先假设有配送员空闲
    while (queue>=k)&&(spare==1)
        %判断哪个配送员空闲
        j=1;
        while (courier(j)==0)&&(j<c);
            j=j+1;
        end
        if (courier(j)==1)            
            courier(j)=0;
            queue=queue-k;
            for l=first:first+k-1
                starttime(l)=time;  %记录顾客开始接受服务的时间
                state(l)=-1;   %顾客离开
            end
            first=first+k;
            servicetime(j)=2*transporttime;
            for l=1:k
                servicetime(j)=servicetime(j)+exprnd(1/mu,1,1);
            end
        else
            spare=0;
        end
    end
    %预测下一个事件发生时间
    if (i<=n)
    eventtime=arrivetime(i);
    else 
    eventtime=inf;
    end
    for j=1:c
        if (courier(j)==0)
        if (servicetime(j)<eventtime)
            eventtime=servicetime(j);
        end
        end
    end
end
reachtime(1)=inflow(1);  %到达时间点
for i=2:n
    reachtime(i)=reachtime(i-1)+inflow(i);
end
for i=1:n
    waittime(i)=starttime(i)-reachtime(i);
end
allwaittime=0;
for i=1:n
    allwaittime=allwaittime+waittime(i);
end
averagewaittime=allwaittime/n+transporttime;   %平均排队等待时间
%运输时间为定值，楼下等待时间取决于客户，可不考虑
end