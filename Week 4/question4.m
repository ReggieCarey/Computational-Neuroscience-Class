clear all;
clc;
close;

load('tuning');

% compute the index of the stimulus vector that maximizes the reponse
[rmax(1), idx_stim(1)] = max(mean(neuron1));
[rmax(2), idx_stim(2)] = max(mean(neuron2));
[rmax(3), idx_stim(3)] = max(mean(neuron3));
[rmax(4), idx_stim(4)] = max(mean(neuron4));

% retrieve the $s_{a}$ for each neuron $a$. values are radians/pi
s = stim(idx_stim)/180;

% develop an inline function that respond using cos as model
response=@(x,idx)gt(cos(pi*x/180-pi*s(idx)),0).*cos(pi*x/180-pi*s(idx));
r=@(x,y)gt(cos(pi*x/180-pi*s(y)),0).*cos(pi*x/180-pi*s(y));

m(1, :) = mean(neuron1) / rmax(1);
m(2, :) = mean(neuron2) / rmax(2);
m(3, :) = mean(neuron3) / rmax(3);
m(4, :) = mean(neuron4) / rmax(4);

% the below is the idealized response of each neuron a. The second
% parameter indexes the four $s_{a}$ patterns retrieving their value
ideal(1,:)=response(stim,1);
ideal(2,:)=response(stim,2);
ideal(3,:)=response(stim,3);
ideal(4,:)=response(stim,4);

figure(3);
plot(stim,[m;ideal*max(max(m))]);
title('Mean response vs Ideal response');

figure(1);
plot(stim,m);
title('Mean response / rmax');
xlabel('wind direction (degrees)');
ylabel('$\left(\frac{f(s)}{r_{\max}}\right)$','interpreter','latex','FontSize',24);

figure(2);
plot(stim,ideal);
title('Idealized response');
xlabel('wind direction (degrees)');
ylabel('[cos(s-sa)]+');

% lets compute direction vectors corresponding to $s_{a}$.  These should be
% identical to the c1-c4 loaded in pop_coding.
v=@(x)[sin(x*pi);cos(x*pi)]';
vdeg=@(x)[sin(x*pi/180);cos(x*pi/180)]';

load('pop_coding');

vector_ideal=@(deg)vdeg(deg)*[c1;c2;c3;c4]';

%for(x=0:15:359) disp(r(x)); end;
%for(x=0:15:359) disp(vector_ideal(x)); end;

ca=[c1;c2;c3;c4];

deg = randi([0 359]);
v = r(deg,1:4);
v_pop = v * ca;
degout = mod(atan2(v_pop(1),v_pop(2))*180/pi,360);
fprintf('using model deg in = %d deg out = %f\n', deg, degout);

idx = randi(length(stim));
v = m(:,idx)';
v_pop = v * ca;
degout = mod(atan2(v_pop(1),v_pop(2))*180/pi,360);
fprintf('using data stim(%d) deg in = %d deg out = %f\n', idx, stim(idx), degout);

v=[mean(r1)/rmax(1),mean(r2)/rmax(2),mean(r3)/rmax(3),mean(r4)/rmax(4)];
v_pop = v * ca;
degout = mod(atan2(v_pop(1),v_pop(2))*180/pi,360);
fprintf('given r the angle of the wind is %f\n', degout);



