clc;
clear all;
close all;

Gaussian_Scale=5;
Nb=1024;
qpsk_ber=QPSKF(Nb,Gaussian_Scale);
pause; 
qam_ber=QAMF(Nb,Gaussian_Scale);
pause;
Bpsk_ber=BPSKF(Nb,Gaussian_Scale);
pause;
