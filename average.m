function averagewaittime = average( n,lamda,c,k,transporttime,mu)
%   n����Ʒ(ע��,nӦΪk��������),������Ӳ���lamda�Ĳ�����;
%   c������Ա;һ������k��;����ʱ��������ʱ��transporttime��¥�µȴ�ʱ�����
%   ¥�µȴ�ʱ����Ӳ���Ϊmu��k�װ����ʷֲ�
inflow=exprnd(1/lamda,n,1);  
for i=1:n
    arrivetime(i)=inflow(i);  %��Ʒʣ�ൽ��ʱ��
    state(i)=0;   %�˿�״̬Ϊδ����
end
courier(1)=1;
for j=1:c
    courier(j)=1; %����
    servicetime(j)=0;  %������Աʣ�����ʱ��
end
queue=0;    %�ӳ�
time=0;  %ģ��ʱ����
eventtime=arrivetime(1);
first=1;  %�ȴ������е�һ���˿ͱ��
i=1;
while (state(n)~=-1)
    time=time+eventtime;   %�ɼ�¼event״̬���Ľ������ٶ�
    %״̬����
    if (i<=n)
    arrivetime(i)=arrivetime(i)-eventtime;
    if (arrivetime(i)==0)
        state(i)=1;   %�˿ͽ������
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
    spare=1;  %�ȼ���������Ա����
    while (queue>=k)&&(spare==1)
        %�ж��ĸ�����Ա����
        j=1;
        while (courier(j)==0)&&(j<c);
            j=j+1;
        end
        if (courier(j)==1)            
            courier(j)=0;
            queue=queue-k;
            for l=first:first+k-1
                starttime(l)=time;  %��¼�˿Ϳ�ʼ���ܷ����ʱ��
                state(l)=-1;   %�˿��뿪
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
    %Ԥ����һ���¼�����ʱ��
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
reachtime(1)=inflow(1);  %����ʱ���
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
averagewaittime=allwaittime/n+transporttime;   %ƽ���Ŷӵȴ�ʱ��
%����ʱ��Ϊ��ֵ��¥�µȴ�ʱ��ȡ���ڿͻ����ɲ�����
end