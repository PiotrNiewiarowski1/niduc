function x = BPSKF(Nb,Gaussian_Scale)
T=1;%ile bitow na sekunde


   b=randi([0,1],1,Nb);

scale=Gaussian_Scale;


NRZ_out=[];
RZ_out=[];
Manchester_out=[];
  
 
Vp=1;
%jak 0 to ujemne jak 1 to dodatnie
for index=1:size(b,2)
 if b(index)==1
 NRZ_out=[NRZ_out (ones(1,200)*Vp)];
 elseif b(index)==0
 NRZ_out=[NRZ_out (ones(1,200)*(-Vp))];
 end
end
 
 
figure(1);
stem(b,'linewidth',3) 
xlabel('Czas (sekundy)')
ylabel('Amplituda')
title('Liczba impulsow przesylanych');
axis([-0.5 8+0.5 -1.2 1.2])
figure(2);
plot(NRZ_out);
xlabel('Czas (sekundy)');
ylabel('Amplituda');
title('Sygnal');
axis([-30 (8*200)+30 -1.5 1.5]);
t=0.005:0.005:Nb;
f=1;
w=2*pi*f*t;
A=1;
Modulated=NRZ_out.*(A*cos(w));
figure; 
plot(Modulated);
xlabel('Czas (sekundy)');
ylabel('Amplituda');
title('Sygnal zmodulowany BPSK');
axis([-30 (8*200)+30 -1.5 1.5]);



sygnal_received=A*cos(w);

y=[];
%demodulacja
demodulated1=Modulated.*(sygnal_received);
demodulated2=Modulated.*(sygnal_received);
demodulated1=addGaussianNoise(demodulated1,scale);
demodulated2=addGaussianNoise(demodulated2,scale+10);
a=sqrt(2/T)*demodulated1;
E=(power(A,2)*T)/2;
s=sqrt(E)*a;

figure; 
plot(demodulated1);
xlabel('Czas (sekundy)');
ylabel('Amplituda');
title('Sygnal podniesiony do kwadratu');
axis([-30 (8*200)+30 -1.5 1.5]);

th=[];
received=[]
for i=1:200:size(demodulated1,2)
 if demodulated1(i)>0
   y=[y  s(i)];
 
   th=[th phase_cos(demodulated2(i))];
 else
    y=[y -s(i)];
    
    th=[th phase_cos(demodulated2(i))];
 end   
end

for i=1:1:length(th)
    if th(i)>=-pi/2 && th(i)<pi/2
        received=[received 1];
    else
        received=[received 0];
    end
end

figure;
stem(received,'linewidth',3) 
title('Odebrane bity');
xlabel('Czas (sekundy)');
ylabel('Amplituda');
axis([-0.5 8+0.5 -1.2 1.2])
figure;
polarplot(th,y,'o');
title('Diagram Konstelacji dla BPSK');



good=0;
bad=0;
time=[];
for i=1:1:length(received)
    if received(i)==b(i)
        good=good+1;
    else
        bad=bad+1;
        time=[time i];
    end
end

BER=bad/length(b);
x=BER;
end

