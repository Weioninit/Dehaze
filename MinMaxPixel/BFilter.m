%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    BFilter-bilateral filter. Takes image L,
%    returns filtered image F
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function F = BFilter(L)


%go over all pixels

F=L;
Rad = 6;
Lambda = 1;
sigma = 200;
[sx,sy] = size(L);
for x0 = 1:sx
    for y0 = 1:sy
        for x = max(x0-Rad,1):min(x0+Rad,sx)
            for y = max(y0-Rad,1):min(y0+Rad,sy)
                dist = (x-x0).^2+(y-y0).^2;
                if (dist>Rad^2 || dist<1)
                    continue;
                end;
                diff = -((L(x,y)-L(x0,y0))/sigma).^2;
                Wab = (Lambda*exp(diff))./(1+dist);
                F(x0,y0) = (L(x0,y0)+ sum(Wab.*L(x,y)))/(1+sum(Wab));
            end
        end
    end
end
return
