function x=phase_cos(a)
   if a<=1 & a>=-1
       x=acos(a);
   elseif a>1
       x=0-acos(1-abs(a-1));
   elseif a<-1
       x=pi+acos(1-abs(a+1));
   end
   end