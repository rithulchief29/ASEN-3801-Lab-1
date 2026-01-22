clear;
close all;
clc;

[const,initial] = getConst(); %call the constant and initial value structures

%Calculates  density at each altitudes
alt = [1000, 2000, 3000, 4000, 5000];
rho = zeros(size(alt)); % initialize density array

for i = 1:length(alt)
    [rho(i), ~, ~, ~, ~, ~] = atm_rho(alt(i)); 
end
%% No Wind
wind_vel = [initial.windu, initial.windv, initial.windw]; %set the initial wind velocity

options = odeset('AbsTol',1e-8,'RelTol',1e-8,'Events',@myEventFcn);%set the tolerances and event function for ode45
[t,x,te,xe,ie] = ode45(@(t,x) objectEOM(t,x,const.rho,const.Cd,const.A,const.m,const.g,wind_vel),[initial.t 5],[initial.x; initial.y; initial.z;...
    initial.ue; initial.ve; initial.we],options); %call ode45 with EOM function and its arguments, timespan, and initial values

heightData = -1*x(:,3); %separate height data from statevector, invert to make intuitive on a plot
ydata = x(:,2); %seperate East data from statevector




figure() %plot the East and Down data (North data is all 0)
plot3(x(:,1),ydata,heightData,'LineWidth',2)
xlabel("x-distance (North) (m)")
ylabel("y-distance (East) (m)")
zlabel("z-distance (Down, inverted) (m)")
title("Ball Trajectory Without Wind")
legend('Trajectory')
grid on
set(legend,...
    'Position',[0.62378869047619 0.723412698412698 0.1875 0.046031746031746]);


%% Wind Speed Variation
windspeed = ["ms1k4" ,"ms1k10", "ms2k4" "ms2k10", "ms3k4" ,"ms3k10", "ms4k4" "ms4k10"]; %create strings to name structures later on
j = 1;
air_speed = [4, 10];
for i = 1:8 %set up a for loop to iterate through different wind speeds

if mod(i, 2) == 1
    wind_vel = air_speed(1);
end
if mod(i, 2) == 0
    wind_vel = air_speed(2);
    j = j+1;
end


options = odeset('AbsTol',1e-8,'RelTol',1e-8,'Events',@myEventFcn);%set tolerances and event function for ode45
[t,x,te,xe,ie] = ode45(@(t,x) objectEOM(t,x,rho(j),const.Cd,const.A,const.m,const.g,wind_vel),[initial.t 5],[initial.x; initial.y; initial.z;...
    initial.ue; initial.ve; initial.we],options); %call ode45 with EOM function and its arguments, timespan, and initial values

windtest.(windspeed(i)).time = t; %record time data for each iteration in a new structure
windtest.(windspeed(i)).data = x; %record statevector for each iteration in a new structure

end


%calculate wind magnitudes
windtest.ms1k4.mag = sqrt(3*4^2);
windtest.ms1k10.mag = sqrt(3*10^2);
windtest.ms2k4.mag = sqrt(3*4^2);
windtest.ms2k10.mag = sqrt(3*10^2);
windtest.ms3k4.mag = sqrt(3*4^2);
windtest.ms3k10.mag = sqrt(3*10^2);
windtest.ms4k4.mag = sqrt(3*4^2);
windtest.ms4k10.mag = sqrt(3*10^2);

xlandingPts = [0; windtest.ms1k4.data(end,1); windtest.ms1k10.data(end,1); windtest.ms2k4.data(end,1); windtest.ms2k10.data(end,1); ...
    windtest.ms3k4.data(end,1); windtest.ms3k10.data(end,1); windtest.ms4k4.data(end,1); windtest.ms4k10.data(end,1)];
ylandingPts = [ydata(end); windtest.ms1k4.data(end,2); windtest.ms1k10.data(end,2); windtest.ms2k4.data(end,2); windtest.ms2k10.data(end,2); ...
    windtest.ms3k4.data(end,2); windtest.ms3k10.data(end,2); windtest.ms4k4.data(end,2); windtest.ms4k10.data(end,2)];
xylandingDist = [ydata(end);sqrt(windtest.ms1k4.data(end,1)^2 + windtest.ms1k4.data(end,2)^2); sqrt(windtest.ms1k10.data(end,1)^2 + windtest.ms1k10.data(end,2)^2);...
    sqrt(windtest.ms2k4.data(end,1)^2 + windtest.ms2k4.data(end,2)^2);sqrt(windtest.ms2k10.data(end,1)^2 + windtest.ms2k10.data(end,2)^2);...
    sqrt(windtest.ms3k4.data(end,1)^2 + windtest.ms3k4.data(end,2)^2); sqrt(windtest.ms3k10.data(end,1)^2 + windtest.ms3k10.data(end,2)^2); ...
    sqrt(windtest.ms4k4.data(end,1)^2 + windtest.ms4k4.data(end,2)^2); sqrt(windtest.ms4k10.data(end,1)^2 + windtest.ms4k10.data(end,2)^2)];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

windIncMatrix = [4;10;4;10;4;10;4;10;4];
xlandingPtsGain = polyfit(windIncMatrix,xlandingPts,1);
xylandingPtsGain = polyfit(windIncMatrix,xylandingDist,1);

figure() %plot different wind magnitude curves

plot3(zeros(length(ydata)),ydata,heightData,LineWidth = 2)
hold on
plot3(zeros(length(ydata)),ydata,heightData,LineWidth = 2)
plot3(windtest.ms1k4.data(:,1),windtest.ms1k4.data(:,2),-1*windtest.ms1k4.data(:,3),LineWidth = 2)
plot3(windtest.ms1k10.data(:,1),windtest.ms1k10.data(:,2),-1*windtest.ms1k10.data(:,3),LineWidth = 2)
plot3(windtest.ms2k4.data(:,1),windtest.ms2k4.data(:,2),-1*windtest.ms2k4.data(:,3),LineWidth=  2)
plot3(windtest.ms2k10.data(:,1),windtest.ms2k10.data(:,2),-1*windtest.ms2k10.data(:,3),LineWidth = 2)
plot3(windtest.ms3k4.data(:,1),windtest.ms3k4.data(:,2),-1*windtest.ms3k4.data(:,3),LineWidth = 2)
plot3(windtest.ms3k10.data(:,1),windtest.ms3k10.data(:,2),-1*windtest.ms3k10.data(:,3),LineWidth = 2)
plot3(windtest.ms4k4.data(:,1),windtest.ms4k4.data(:,2),-1*windtest.ms4k4.data(:,3),LineWidth = 2)
plot3(windtest.ms4k10.data(:,1),windtest.ms4k10.data(:,2),-1*windtest.ms4k10.data(:,3),LineWidth = 2)


plot3([0;windtest.ms1k4.data(end,1)],[0,windtest.ms1k4.data(end,2)],[0,-1*windtest.ms1k4.data(end,3)],'--k',LineWidth = 1)
plot3([0;windtest.ms1k10.data(end,1)],[0,windtest.ms1k10.data(end,2)],[0,-1*windtest.ms1k10.data(end,3)],'--k',LineWidth = 1)
plot3([0;windtest.ms2k4.data(end,1)],[0,windtest.ms2k4.data(end,2)],[0,-1*windtest.ms2k4.data(end,3)],'--k',LineWidth = 1)
plot3([0;windtest.ms2k10.data(end,1)],[0,windtest.ms2k10.data(end,2)],[0,-1*windtest.ms2k10.data(end,3)],'--k',LineWidth = 1)
plot3([0;windtest.ms3k4.data(end,1)],[0,windtest.ms3k4.data(end,2)],[0,-1*windtest.ms3k4.data(end,3)],'--k',LineWidth = 1)
plot3([0;windtest.ms3k10.data(end,1)],[0,windtest.ms3k10.data(end,2)],[0,-1*windtest.ms3k10.data(end,3)],'--k',LineWidth = 1)
plot3([0;windtest.ms4k4.data(end,1)],[0,windtest.ms4k4.data(end,2)],[0,-1*windtest.ms4k4.data(end,3)],'--k',LineWidth = 1)
plot3([0;windtest.ms4k10.data(end,1)],[0,windtest.ms4k10.data(end,2)],[0,-1*windtest.ms4k10.data(end,3)],'--k',LineWidth = 1)

xlabel("x-distance (North) (m)")
ylabel("y-distance (East) (m)")
zlabel("z-distance (Down, inverted) (m)")
title("Ball Trajectory With Wind and Altitude")
grid on
%legend('4 m/s wind @ 1000 m','10 m/s wind @ 1000 m','4 m/s wind @ 2000 m', '10 m/s wind @ 2000 m', '4 m/s wind @ 3000 m', '10 m/s wind @ 3000 m', '4 m/s wind @ 4000 m', '10 m/s wind @ 4000 m');
%set(legend,...
   % 'Position',[0.538491071428572 0.687103174603175 0.342261904761905 0.234523809523809]);
%view([-41.7 33.3184965212965]);
hold off



figure() %plot different wind magnitudes on x+z plot, to see change in landing position in x

plot(windtest.ms1k4.data(:,1),-1*windtest.ms1k4.data(:,3),LineWidth = 2)
hold on
plot(windtest.ms1k10.data(:,1),-1*windtest.ms1k10.data(:,3),LineWidth = 2)
plot(windtest.ms2k4.data(:,1),-1*windtest.ms2k4.data(:,3),LineWidth=  2)
plot(windtest.ms2k10.data(:,1),-1*windtest.ms2k10.data(:,3),LineWidth = 2)
plot(windtest.ms3k4.data(:,1),-1*windtest.ms3k4.data(:,3),LineWidth = 2)
plot(windtest.ms3k10.data(:,1),-1*windtest.ms3k10.data(:,3),LineWidth = 2)
plot(windtest.ms4k4.data(:,1),-1*windtest.ms4k4.data(:,3),LineWidth = 2)
plot(windtest.ms4k10.data(:,1),-1*windtest.ms4k10.data(:,3),LineWidth = 2)

xlabel("x-distance (North) (m)")
ylabel("z-distance (Down, inverted) (m)")
title("Ball Trajectory With Wind and Altitude (x+z view)")
grid on
%legend('3.46 m/s magnitude wind','6.93 m/s magnitude wind','10.39 m/s magnitude wind', '13.85 m/s magnitude wind','17.32 m/s magnitude wind')

figure()
plot(windIncMatrix,xlandingPts,linewidth = 2)
hold on
plot(windIncMatrix,xlandingPtsGain(1)*windIncMatrix + xlandingPtsGain(2),linewidth = 2)
xlabel('Windspeed increased (m/s)')
ylabel('Distance defelected increased (m)')
title('Northern Deflection with North Wind Increase')
legend('Raw Deflection','Line of Best Fit','Location','northwest')







%% Functions
function xdot = objectEOM(t,x,rho,Cd,A,m,g,wind_vel)


vaMag = sqrt((x(4)-wind_vel(1))^2 + (x(5)-wind_vel(1))^2 + (x(6) - wind_vel(1))^2); %magitude of the airspeed vector

ue = x(4); %u component of the a/c velocity, m/s
ve = x(5); %v component of the a/c velocity, m/s
we = x(6); %w component of the a/c velocity, m/s

au = (-.5*rho*A*Cd*vaMag*(ue - wind_vel(1)))/m; %u component of the a/c acceleration, m/s^2
av = (-.5*rho*A*Cd*vaMag*(ve - wind_vel(1)))/m; %v component of the a/c acceleration, m/s^2
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
const.m = .002; %g
const.g = 9.8; %m/s^2
const.alt = 1655; %m
[const.rho,~,~,~,~,~] = atm_rho(const.alt);


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

