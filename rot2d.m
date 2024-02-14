function y=rot2d(x,angle)
% Usage ... y=rot2d(x,angle)
%
% x is a row vector and angle is in degrees

angle=angle*(pi/180);
rotm=[cos(angle) -sin(angle);sin(angle) cos(angle)];

if size(x,1)==1,
  y=(rotm*(x.')).';
else,
  for m=1:size(x,1),
    y(m,:)=(rotm*(x(m,:).')).';
  end;
end;

