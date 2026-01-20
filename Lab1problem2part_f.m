% Contributors: Alonso Jimenes
% Course number: ASEN 3801
% File name: massAndWindspeedEffects
% Created: 9/8/23
clear;
close all;
clc;

[const,initial] = getConst(); %call the constant and initial value structures
%
%% No Wind
wind_vel = [initial.windu, initial.windv, initial.windw]; %set the initial wind velocity

options = odeset('AbsTol',1e-8,'RelTol',1e-8,'Events',@myEventFcn);%set the tolerances and event function for ode45
[t,x_prob2c,te,xe,ie] = ode45(@(t,x) objectEOM(t,x,const.rho,const.Cd,const.A,const.m,const.g,wind_vel),[initial.t 5],[initial.x; initial.y; initial.z;...
    initial.ue; initial.ve; initial.we],options); %call ode45 with EOM function and its arguments, timespan, and initial values

heightData = -1*x_prob2c(:,3); %separate height data from statevector, invert to make intuitive on a plot
ydata = x_prob2c(:,2); %seperate East data from statevector




figure() %plot the East and Down data (North data is all 0)
plot3(x_prob2c(:,1),ydata,heightData,'LineWidth',2)
xlabel("x-distance (North) (m)")
ylabel("y-distance (East) (m)")
zlabel("z-distance (Down, inverted) (m)")
title("Ball Trajectory Without Wind")
legend('Trajectory')
grid on
set(legend,...
    'Position',[0.62378869047619 0.723412698412698 0.1875 0.046031746031746]);
%{
%% Wind Speed Variation
windspeed = ["ms2", "ms4" ,"ms6","ms8","ms10"]; %create strings to name structures later on


for i = 1:5 %set up a for loop to iterate through different wind speeds

wind_vel = i*2*[1,1,1 ]; %set wind speed to vary by 2 m/s every iteration



options = odeset('AbsTol',1e-8,'RelTol',1e-8,'Events',@myEventFcn);%set tolerances and event function for ode45
[t,x,te,xe,ie] = ode45(@(t,x) objectEOM(t,x,const.rho,const.Cd,const.A,const.m,const.g,wind_vel),[initial.t 5],[initial.x; initial.y; initial.z;...
    initial.ue; initial.ve; initial.we],options); %call ode45 with EOM function and its arguments, timespan, and initial values


windtest.(windspeed(i)).time = t; %record time data for each iteration in a new structure
windtest.(windspeed(i)).data = x; %record statevector for each iteration in a new structure
end

%calculate wind magnitudes
windtest.ms2.mag = sqrt(3*2^2);
windtest.ms4.mag = sqrt(3*4^2);
windtest.ms6.mag = sqrt(3*6^2);
windtest.ms8.mag = sqrt(3*8^2);
windtest.ms10.mag = sqrt(3*10^2);

xlandingPts = [0; windtest.ms2.data(end,1); windtest.ms4.data(end,1); windtest.ms6.data(end,1); windtest.ms8.data(end,1); ...
    windtest.ms10.data(end,1)];
ylandingPts = [ydata(end); windtest.ms2.data(end,2); windtest.ms4.data(end,2); windtest.ms6.data(end,2); windtest.ms8.data(end,2); ...
    windtest.ms10.data(end,2)];
xylandingDist = [ydata(end);
    sqrt(windtest.ms2.data(end,1)^2 + windtest.ms2.data(end,2)^2);
    sqrt(windtest.ms4.data(end,1)^2 + windtest.ms4.data(end,2)^2);...
    sqrt(windtest.ms6.data(end,1)^2 + windtest.ms6.data(end,2)^2);
    sqrt(windtest.ms8.data(end,1)^2 + windtest.ms8.data(end,2)^2);...
    sqrt(windtest.ms10.data(end,1)^2 + windtest.ms10.data(end,2)^2)];

windIncMatrix = [0;2;4;6;8;10];
xlandingPtsGain = polyfit(windIncMatrix,xlandingPts,1);
xylandingPtsGain = polyfit(windIncMatrix,xylandingDist,1);

figure() %plot different wind magnitude curves

plot3(zeros(length(ydata)),ydata,heightData,LineWidth = 2)
hold on
%plot3(zeros(length(ydata)),ydata,heightData,LineWidth = 2)
plot3(windtest.ms2.data(:,1),windtest.ms2.data(:,2),-1*windtest.ms2.data(:,3),LineWidth = 2)
plot3(windtest.ms4.data(:,1),windtest.ms4.data(:,2),-1*windtest.ms4.data(:,3),LineWidth = 2)
plot3(windtest.ms6.data(:,1),windtest.ms6.data(:,2),-1*windtest.ms6.data(:,3),LineWidth=  2)
plot3(windtest.ms8.data(:,1),windtest.ms8.data(:,2),-1*windtest.ms8.data(:,3),LineWidth = 2)
plot3(windtest.ms10.data(:,1),windtest.ms10.data(:,2),-1*windtest.ms10.data(:,3),LineWidth = 2)


plot3([0;windtest.ms2.data(end,1)],[0,windtest.ms2.data(end,2)],[0,-1*windtest.ms2.data(end,3)],'--k',LineWidth = 1)
plot3([0;windtest.ms4.data(end,1)],[0,windtest.ms4.data(end,2)],[0,-1*windtest.ms4.data(end,3)],'--k',LineWidth = 1)
plot3([0;windtest.ms6.data(end,1)],[0,windtest.ms6.data(end,2)],[0,-1*windtest.ms6.data(end,3)],'--k',LineWidth = 1)
plot3([0;windtest.ms8.data(end,1)],[0,windtest.ms8.data(end,2)],[0,-1*windtest.ms8.data(end,3)],'--k',LineWidth = 1)
plot3([0;windtest.ms10.data(end,1)],[0,windtest.ms10.data(end,2)],[0,-1*windtest.ms10.data(end,3)],'--k',LineWidth = 1)

xlabel("x-distance (North) (m)")
ylabel("y-distance (East) (m)")
zlabel("z-distance (Down, inverted) (m)")
title("Ball Trajectory With Wind")
grid on
legend('0 m/s magnitude wind','3.46 m/s magnitude wind','6.93 m/s magnitude wind','10.39 m/s magnitude wind', '13.85 m/s magnitude wind','17.32 m/s magnitude wind')
set(legend,...
    'Position',[0.538491071428572 0.687103174603175 0.342261904761905 0.234523809523809]);
view([-41.7 33.3184965212965]);
hold off



figure() %plot different wind magnitudes on x+z plot, to see change in landing position in x

plot(windtest.ms2.data(:,1),-1*windtest.ms2.data(:,3),LineWidth = 2)
hold on
plot(windtest.ms4.data(:,1),-1*windtest.ms4.data(:,3),LineWidth = 2)
plot(windtest.ms6.data(:,1),-1*windtest.ms6.data(:,3),LineWidth=  2)
plot(windtest.ms8.data(:,1),-1*windtest.ms8.data(:,3),LineWidth = 2)
plot(windtest.ms10.data(:,1),-1*windtest.ms10.data(:,3),LineWidth = 2)

xlabel("x-distance (North) (m)")
ylabel("z-distance (Down, inverted) (m)")
title("Ball Trajectory With Wind (x+z view)")
grid on
legend('3.46 m/s magnitude wind','6.93 m/s magnitude wind','10.39 m/s magnitude wind', '13.85 m/s magnitude wind','17.32 m/s magnitude wind')

figure()
plot(windIncMatrix,xlandingPts,linewidth = 2)
hold on
plot(windIncMatrix,xlandingPtsGain(1)*windIncMatrix + xlandingPtsGain(2),linewidth = 2)
xlabel('Windspeed increased (m/s)')
ylabel('Distance defelected increased (m)')
title('Northern Deflection with North Wind Increase')
legend('Raw Deflection','Line of Best Fit','Location','northwest')
%}
%% problem 2f
% no wind speed
mass = const.m*[1,2,4,8,16]; % vector of different mass values
KE = 0.5*vecnorm([x_prob2c(:,4),x_prob2c(:,5),x_prob2c(:,6)],2,2).^2 * const.m;% Kinetic Energy in problem 2c
unitVec = [initial.ue, initial.ve ,initial.we] / norm([x_prob2c(1,4),x_prob2c(1,5),x_prob2c(1,6)]);% unit vector of air-rel. velocity in problem 2c, <Vx,Vy,Vz>/magnitude(V)
Vmag = sqrt(2*KE(1,1)./mass');% Magnitude of air-rel. velocity req. for each mass to maintain the INITIAL KE in problem 2c
Vel_KE = Vmag.*unitVec; % Vector of the air-rel. velocity for each  mass w/ same KE as prob 2c, used in Initial condition vector for ode 45 
wind_vel = [initial.windu, initial.windv, initial.windw]; %set the initial wind velocity

names = ["A","B","C","D","E"]; %  string vector used to label each value of mass
figure()
for ii=1:5 % set up a for loop to iterate through different mass values
[t,x_2f,te,xe,ie] = ode45(@(t,x) objectEOM(t,x,const.rho,const.Cd,const.A,mass(ii),const.g,wind_vel),[initial.t 5],[initial.x; initial.y; initial.z;...
    Vel_KE(ii,1); Vel_KE(ii,2); Vel_KE(ii,3)],options); %call ode45 with EOM function and its arguments, timespan, and initial values
heightData2f = -1*x_2f(:,3); %separate height data from statevector, invert to make intuitive on a plot
ydata2f = x_2f(:,2); %seperate East data from statevector
x_PROB2f.(names(ii)) = x_2f; % STORES DATA

%figure() %plot the East and Down data (North data is all 0)
plot3(x_2f(:,1),ydata2f,heightData2f,'LineWidth',2)
hold on
xlabel("x-distance (North) (m)")
ylabel("y-distance (East) (m)")
zlabel("z-distance (Down, inverted) (m)")
title("Ball Trajectory Without Wind")
lgd(ii) = " Mass "+ names(ii);
grid on

end
legend(lgd)
set(legend,...
    'Position',[0.62378869047619 0.723412698412698 0.1875 0.046031746031746]);
hold off
print('Trajectory vs mass','-dpng')
%
%% Problem 2f w/ wind speed 
%
windnames = ["WindVel2", "WindVel4" ,"WindVel6","WindVel8","WindVel10"];% string vector used to label the different wind speeds
LineVec = ["--","-.","-"]; % string vector used to assign linestyle based on wind veloctiy
ColorVec = [orderedcolors("gem")]; % matab default plot colors
ColorVec = {ColorVec(1,:),ColorVec(2,:),ColorVec(3,:)}; % string vector used to assing line color based on mass
figure()
counterOut = 0; % variable used to index legend
for i = 1:2:5 % set up a for loop to iterate through different mass values , will only use 3 for clarity
    counterIn = 0;% variable used to index legend
    for j = 1:2:5 % set up a for loop to iterate through different wind speeds, will only use 3 for clarity

        wind_vel_f = j*2*[1,1,1]; % set wind speed to vary by 2 m/s every iteration
        options = odeset('AbsTol',1e-8,'RelTol',1e-8,'Events',@myEventFcn);%set tolerances and event function for ode45
        [t,x,te,xe,ie] = ode45(@(t,x) objectEOM(t,x,const.rho,const.Cd,const.A,mass(i),const.g,wind_vel_f ),[initial.t 5],[initial.x; initial.y; initial.z;...
            Vel_KE(i,1); Vel_KE(i,2); Vel_KE(i,3)],options); %call ode45 with EOM function and its arguments, timespan, and initial values

        windtest2F.(names(i)).(windnames(j)).time = t; %record time data for each iteration in a new structure
        windtest2F.(names(i)).(windnames(i)).data = x; %record statevector for each iteration in a new structure

        plot3(windtest2F.(names(i)).(windnames(i)).data(:,1),windtest2F.(names(i)).(windnames(i)).data(:,2),-1*windtest2F.(names(i)).(windnames(i)).data(:,3),'LineWidth',2,LineStyle =LineVec(j-counterIn),Color=ColorVec{i-counterOut})
        hold on
        lgdf(i-counterOut,j-counterIn) = " Mass "+ names(i) + " "+ windnames(j); % legend entry for each mass and wind speed combo
        dist_land.(names(i)).(windnames(j)) = getDist( [initial.x,initial.y,initial.z], [windtest2F.(names(i)).(windnames(i)).data(end,1), windtest2F.(names(i)).(windnames(i)).data(end,2), windtest2F.(names(i)).(windnames(i)).data(end,3)]);
        counterIn = counterIn +1;
    end
    counterOut = counterOut+1;
end
grid on
xlabel("x-distance (North) (m)")
ylabel("y-distance (East) (m)")
zlabel("z-distance (Down, inverted) (m)")
title("Ball Trajectory with different Windspeed and Mass values")
set(legend,...
'Position',[0.62378869047619 0.723412698412698 0.1875 0.046031746031746]);
legend(lgdf)
hold off
%print('Trajectory vs mass & windspeed','-dpng')

%% Functions
function xdot = objectEOM(t,x,rho,Cd,A,m,g,wind_vel)


vaMag = sqrt((x(4)-wind_vel(1))^2 + (x(5)-wind_vel(2))^2 + (x(6) - wind_vel(3))^2); %magitude of the airspeed vector

ue = x(4); %u component of the a/c velocity, m/s
ve = x(5); %v component of the a/c velocity, m/s
we = x(6); %w component of the a/c velocity, m/s

au = (-.5*rho*A*Cd*vaMag*(ue - wind_vel(1)))/m; %u component of the a/c acceleration, m/s^2
av = (-.5*rho*A*Cd*vaMag*(ve - wind_vel(2)))/m; %v component of the a/c acceleration, m/s^2
aw = (-.5*rho*A*Cd*vaMag*(we - wind_vel(1)))/m + g; %w component of the a/c acceleration, m/s^2


xdot = [ue; ve; we; au; av; aw;];



end


function  [value,isterminal,direction] = myEventFcn(t,x)

value = x(3);
isterminal = 1;
direction = 0;

end

function [const,initial] = getConst()

const.Cd = .6; %nd
const.d = .02; %m
const.A = pi*(const.d/2)^2; %m^2
const.m = .05; %kg
const.g = 9.8; %m/s^2
const.alt = 1655; %m
[const.rho,~,~,~,~,~] = stdatmo(const.alt);


initial.ue = 0; %m/s
initial.ve = 20; %m/s
initial.we = -20; %m/s

initial.windu = 0;
initial.windv = 0;
initial.windw = 0;

initial.t = 0;

initial.x = 0;
initial.y = 0;
initial.z = 0;



end
function distance = getDist(origin,final)
%
% Inputs: origin = [x,y,z]’ origin of object in inertial coordinates 
%          final = [x,y,z]’ final/landing points of object in inertial coordinates 
%
% Outputs: distance : scalar measuring the distance from the origin to 
%                       the final/landing pts
%
% Methodology: Use distance formula d = sqrt( (x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2 )
%               to calculate distance from the origin 

x1 = origin(1);
x2 = final(1);
x = x2 - x1;

y1 = origin(2);
y2 = final(2);
y = y2 - y1;

z1 = origin(3);
z2 = final(3);
z = z2-z1;

distance = sqrt(x^2 + y^2 + z^2);
end


