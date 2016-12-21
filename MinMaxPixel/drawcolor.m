function [out]= drawcolor(v)
[m,n]=size(v);
c=1;
for i=1:m
    for j=1:n
 if v(i,j)<=0
    R(i,j)=0;
    G(i,j)=0;
    B(i,j)=1;
 else if v(i,j)<=c/4
    R(i,j)=0;
    G(i,j)=4*v(i,j);
    B(i,j)=c;
else if v(i,j)<=c/2
        R(i,j)=0;
        G(i,j)=c;
        B(i,j)=-4*v(i,j)+2*c;
    else if v(i,j)<=3*c/4
            R(i,j)=4*v(i,j)-2*c;
            G(i,j)=c;
            B(i,j)=0;
        else
            R(i,j)=c;
            G(i,j)=-4*v(i,j)+4*c;
            B(i,j)=0;
        end
     end
    end
end
    end
end
for i=1:m
    for j=1:n
        out(i,j,1)=R(i,j);
        out(i,j,2)=G(i,j);
        out(i,j,3)=B(i,j);
    end
end
