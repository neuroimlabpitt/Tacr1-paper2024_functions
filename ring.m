function y=ring(inmat,x0,y0,wx,wy,ang,rrw)
% Usage ... y=ring(inmat,x0,y0,wx,wy,ang,rrw)

if length(rrw)==1, rrw=[rrw rrw]; end;

tmp1=ellipse(inmat,x0,y0,wx+rrw(1),wy+rr(2),ang,1);
tmp2=ellipse(inmat,x0,y0,wx,wy,ang,1);

y=tmp1-tmp2;

if nargout==0,
   show(y),
   clear y
end;
