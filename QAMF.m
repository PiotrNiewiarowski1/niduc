function x = QAMF(Nb,Gaussian_Scale)
 scale=Gaussian_Scale;
 data=randi([0,1],1,Nb);
figure(1)
stem(data, 'linewidth',1), grid on;
title('  Sygnal przed transmisja ');
axis([ 0 4*16 0 1.5]);
Nb=length(data);


data_NZR=2*data-1;
s_p_data=reshape(data_NZR,4,length(data)/4);  

br=10.^6; 
f=br; 
T=1/br;
t=T/99:T/99:T; 
 
y=[];
y_1=[];
y_2=[];
y_3=[];
y_4=[];
d=[];
h=[];
g=[];
j=[];
for(i=1:length(data)/4)
    y1=s_p_data(1,i)*cos(2*pi*f*t); 
    y2=s_p_data(2,i)*sin(2*pi*f*t);
    y3=s_p_data(3,i)*2.*cos(2*pi*f*t); 
    y4=s_p_data(4,i)*2.*sin(2*pi*f*t); 
    y_1=[y_1 y1]; 
    y_2=[y_2 y2];
    y_3=[y_3 y1]; 
    y_4=[y_4 y2];
    y=[y y1+y2+y3+y4];
    d=[d (y1.*cos(2*pi*f*t))];
    h=[h (y2.*sin(2*pi*f*t))];
    g=[g (y3.*2.*cos(2*pi*f*t))];
    j=[j (y4.*2.*sin(2*pi*f*t))];
    
end
Tx_sig=y; 
tt=T/99:T/99:(T*length(data))/4;


d=addGaussianNoise(d,scale);
h=addGaussianNoise(h,scale);
g=addGaussianNoise(g,scale+10);
j=addGaussianNoise(j,scale+10);
k=d+h+g+j;

 
figure(2)
 
subplot(5,1,1);
plot(tt,y_1,'linewidth',3), grid on;
title('Sk³adowe modulacji 16QAM');
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 16*power(10,-6) -1 1 ]);
 
subplot(5,1,2);
plot(tt,y_2,'linewidth',3), grid on;

xlabel('czas');
ylabel(' amplituda');
 axis([ 0 16*power(10,-6) -1 1 ]);
 
 
subplot(5,1,3);
plot(tt,y_3,'r','linewidth',3), grid on;

xlabel('czas');
ylabel(' amplituda');
axis([ 0 16*power(10,-6) -1 1 ])

subplot(5,1,4);
plot(tt,y_4,'r','linewidth',3), grid on;

xlabel('czas');
ylabel(' amplituda');
axis([ 0 16*power(10,-6) -1 1 ])

subplot(5,1,5);
plot(tt,Tx_sig,'r','linewidth',3), grid on;
title('Sygna³ zmodulowany 16QAM');
xlabel('czas');
ylabel(' amplituda');
axis([ 0 16*power(10,-6) -5 5 ])


figure(3)
subplot(5,1,1)
plot(tt,d,'b','linewidth',3), grid on;
title('Sk³adowe demodulacji 16QAM');
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 16*power(10,-6) -1 1 ]);
 
 
subplot(5,1,2)
plot(tt,h,'g','linewidth',3), grid on;
 axis([ 0 16*power(10,-6) -1 1 ]);
 xlabel('czas');
ylabel(' amplituda');
 
subplot(5,1,3)
plot(tt,g,'r','linewidth',3), grid on;
 axis([ 0 16*power(10,-6) -4 4 ]);
 xlabel('czas');
ylabel(' amplituda');
 
subplot(5,1,4)
plot(tt,j,'r','linewidth',3), grid on;
 axis([ 0 16*power(10,-6) -4 4 ]);
 xlabel('czas');
ylabel(' amplituda');
 
subplot(5,1,5)
plot(tt,k,'r','linewidth',3), grid on;
title('Demodulacja 16QAM');
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 16*power(10,-6) -5 5 ]);
 
 q=d+h;
 w=j+g;
 
 figure(4)
subplot(6,1,1)
plot(tt,d,'b','linewidth',3), grid on;
title('1 grupa(x)');
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 16*power(10,-6) -1 1 ]);
 
subplot(6,1,2)
plot(tt,h,'g','linewidth',3), grid on;
 axis([ 0 16*power(10,-6) -1 1 ]);
 xlabel('czas');
ylabel(' amplituda');
 
subplot(6,1,3)
plot(tt,q,'r','linewidth',3), grid on;
title('Suma sygna³ow pierwszej grupy');
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 16*power(10,-6) -1 1 ]);
 
subplot(6,1,4)
plot(tt,g,'r','linewidth',3), grid on;
title('2 grupa (y)');
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 16*power(10,-6) -4 4 ]);
 
subplot(6,1,5)
plot(tt,j,'r','linewidth',3), grid on;
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 16*power(10,-6) -5 5 ]);
 
 subplot(6,1,6)
plot(tt,w,'r','linewidth',3), grid on;
title('Suma sygna³ów 2 grupy');
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 16*power(10,-6) -5 5 ]);
 
 S=[];
 s=[];
 for index=2:99:length(k)
     if q(index)+q(index+25)>1.5
            S=[S (d(index)+h(index))];
    elseif q(index)+q(index+25)<-0.75
          S=[S (d(index)+h(index+25))];
    elseif q(index)>q(index+25)
          
          S=[S (d(index)-(h(index+25)))];
     else      
        S=[S (d(index)+h(index))];
    end
 end
 
 for index=2:99:length(k)
      if w(index)+w(index+25)>3.5
             s=[s -5+g(index)+j(index)];
     elseif w(index)+w(index+25)<-3
           s=[s 6+g(index)+j(index)];
     elseif w(index)>w(index+25)
           
           s=[s -6+g(index)+j(index)];
      else      
         s=[s 5+g(index)+j(index)];
     end
  end

figure(5)
plot(S,s,'o','MarkerFaceColor','r'), grid on;
title('Diagram konstelacji 16QAM');
xlabel('Rozkodowanie kodem Greya grupy 1');
ylabel('Rozkodowanie kodem Greya grypy 2');
 axis([ -2.5 2.5 -2.5 2.5 ]);
 
 received=[];
 
 for i=1:1:length(S)
     if S(i)<=-1.5
         received=[received 0 0];
     elseif S(i)<=0 && S(i)>-1.5
         received=[received 0 1];
     elseif S(i)>0 && S(i)<1.5
         received=[received 1 1];
     else
         received=[received 1 0];
     end
     
    if s(i)>=1.5
        received = [received 0 0];
    elseif s(i)>=0 && s(i)<1.5
        received=[received 0 1];
    elseif s(i)<0 && s(i)>=-1.5
        received=[received 1 1];
    else
        received=[received 1 0];
    end
 end
 figure(6)
 stem(received, 'linewidth',1), grid on;
 title('Sygna³ po transmisji');
 axis([ 0 4*16 0 1.5]);

time=[];
 good=0;
 bad=0;
 for i=1:1:length(received)
     if data(i)==received(i)
         good=good+1;
     else
         bad=bad+1;
         time=[time i];
     end
 end
BER=bad/length(data);
x=BER;
end

