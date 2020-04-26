function xp = collision(xm)

global gamma alpha

xp = [-sign(xm(1)-gamma)*alpha + gamma; ...
xm(2)*cos(2*alpha)]; %; ...
%xm(3) + sign(x(1)-gamma)*2*l*sin(alpha)];

end
