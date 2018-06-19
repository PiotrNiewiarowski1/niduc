BPSK=[0];
QPSK=[0];
QAM=[0];

a=0;
b=0;
c=0;
X=[0];

for i=1:1:10
    d=1024*i;
    for index=1:1:10
        a=a+BPSKF(d);
    end
    a=a/10;
    for index=1:1:10
        b=b+QPSKF(d);
    end
    b=b/10;
    for index=1:1:10
        c=c+QAMF(d);
    end
    c=c/10;
    BPSK=[BPSK a];
    QPSK=[QPSK b];
    QAM=[QAM c];
    X=[X d];
    a=0;
    b=0;
    c=0;
    
  
end

plot(X,BPSK,'r','linewidth',3)
hold on;
title('Zale¿noœæ BER dla poszczególnych modulacji');
xlabel('iloœæ bitów');
 ylabel('BER');
plot(X,QPSK,'g','linewidth',3)


plot(X,QAM,'b','linewidth',3)

legend('BPSK','QPSK','16QAM');
hold off;
