function x = QPSKF(Nb,Gaussian_Scale)

 scale=Gaussian_Scale;
 data=randi([0,1],1,Nb);
%  data=[0 0 0 1 1 0 1 1]
%  Numer_of_bit=8
 
figure(1)
stem(data, 'linewidth',3), grid on;
title('  Sygnal przed transmisja ');
axis([ 0 11 0 1.5]);
 
data_NZR=2*data-1;
s_p_data=reshape(data_NZR,2,length(data)/2);  
 
 
br=10.^6; 
f=br; 
T=1/br;
t=T/99:T/99:T; 
 
 
 
y=[];
y_in=[];
y_qd=[];
d=[];
h=[];
for(i=1:length(data)/2)
    y1=s_p_data(1,i)*cos(2*pi*f*t); 
    y2=s_p_data(2,i)*sin(2*pi*f*t); 
    y_in=[y_in y1]; 
    y_qd=[y_qd y2]; 
    y=[y y1+y2];
    d=[d (y1.*cos(2*pi*f*t))];
    h=[h (y2.*sin(2*pi*f*t))];
end
d1=addGaussianNoise(d,scale);
d2=addGaussianNoise(d,scale+10);
h1=addGaussianNoise(h,scale);
h2=addGaussianNoise(h,scale+10);
g=d+h;
Tx_sig=y; 
tt=T/99:T/99:(T*length(data))/2;
 
figure(2)
 
subplot(3,1,1);
plot(tt,y_in,'linewidth',3), grid on;
title(' wykres pierwszej sk³adowej modulacji QPSK ');
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 4*power(10,-6) -1 1 ]);
 
subplot(3,1,2);
plot(tt,y_qd,'linewidth',3), grid on;
title('wykres drugiej sk³adowej modulacji QPSK ');
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 4*power(10,-6) -1 1 ]);
 
 
subplot(3,1,3);
plot(tt,Tx_sig,'r','linewidth',3), grid on;
title('Sygna³ zmodulowany QPSK (suma obu sk³adowych)');
xlabel('czas');
ylabel(' amplituda');
axis([ 0 4*power(10,-6) -2 2 ])
 
figure(3)
subplot(3,1,1)
plot(tt,d,'b','linewidth',3), grid on;
title('Demodulacja pierwszej sk³adwoej QPSK');
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 4*power(10,-6) -1 1 ]);
subplot(3,1,2)

plot(tt,h,'g','linewidth',3), grid on;
title('Demodulacja drugiej sk³adowej QPSK');
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 4*power(10,-6) -1 1 ]);
 
subplot(3,1,3)
plot(tt,g,'r','linewidth',3), grid on;
title('Sygna³ zdemodulowany QPSK');
xlabel('czas');
ylabel(' amplituda');
 axis([ 0 4*power(10,-6) -2 2 ]);
th=[];

received=[];
S=[];
for index=2:99:length(g)
    if g(index)+g(index+25)>1.5

              th=[th  5/4*pi+phase_cos(d2(index))+phase_sin(h2(index+25))];
            
            S=[S (d1(index)+h1(index))];
                
    elseif g(index)+g(index+25)<-0.75

              th=[th -1/4*pi+phase_cos(d2(index))+phase_sin(h2(index+25))];
              
          S=[S (-d1(index)-h1(index))];
        
    elseif g(index)>g(index+25)

          th=[th 1/4*pi+phase_cos(d2(index))+phase_sin(h2(index+25))];
           
          S=[S (+d1(index)-h2(index))];
            
    else
        th=[th -1/4*pi+phase_cos(d2(index))+phase_sin(h2(index+25))];
        
         S=[S (-d1(index)+h1(index))];
          
    end
   
end

  figure(4)
  polarplot(th,S,'o');
  title('Diagram Konstelacji dla QPSK');


  
 

for i=1:1:length(th)
    if th(i)>=0 && th(i)<pi/2
        received =[received 1 0];
    elseif th(i)>=pi/2 && th(i)<pi
        received =[received 0 0];
    elseif th(i)>=pi && th(i)<3*pi/2
        received =[received 0 1];
    elseif th(i)>=3*pi/2 && th(i)<2*pi
        received = [received 1 1];
    end
end

 figure(5)
stem(received, 'linewidth',3), grid on;
title('  Sygnal odebrany ');
axis([ 0 11 0 1.5]);

good=0;
bad=0;
time=[];
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

