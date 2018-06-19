function x=phase_sin(a)
    
   if a<=1 & a>=0
       x=asin(a);
   elseif a>1
       x=pi/2 + asin(a-1);
   elseif a<0
       a=a+1;
       x=asin(a);
   end
end

