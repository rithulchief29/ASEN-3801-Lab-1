clear;
close all;
clc;

%Contributors: Colby Muchlinski, Alonso Jimenes Hernandez, Rithul
%Rengarajan
%Course Number: ASEN 3801
%FileName: Lab1part2.m
%Created: 1/13/2026

[const,initial] = getConst(); %call the constant and initial value structures

%% No Wind
wind_vel = [initial.windu, initial.windv, initial.windw]; %set the initial wind velocity

options = odeset('AbsTol',1e-8,'RelTol',1e-8,'Events',@myEventFcn);%set the tolerances and event function for ode45
[t,x,te,xe,ie] = ode45(@(t,x) objectEOM(t,x,const.rho,const.Cd,const.A,const.m,const.g,wind_vel),[initial.t 5],[initial.xpos; initial.ypos; initial.zpos;...
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
hold off
print("NoWind",'-r300','-dpng')

%% Wind Speed Variation
windspeed = ["ms2", "ms4" ,"ms6","ms8","ms10"]; %create strings to name structures later on


for i = 1:5 %set up a for loop to iterate through different wind speeds

wind_vel = [i*2,0,0 ]; %set wind speed to vary by 2 m/s every iteration



options = odeset('AbsTol',1e-8,'RelTol',1e-8,'Events',@myEventFcn);%set tolerances and event function for ode45
[t,x,te,xe,ie] = ode45(@(t,x) objectEOM(t,x,const.rho,const.Cd,const.A,const.m,const.g,wind_vel),[initial.t 5],[initial.xpos; initial.ypos; initial.zpos;...
    initial.ue; initial.ve; initial.we],options); %call ode45 with EOM function and its arguments, timespan, and initial values


windtest.(windspeed(i)).time = t; %record time data for each iteration in a new structure
windtest.(windspeed(i)).data = x; %record statevector for each iteration in a new structure
end




xlandingPts = [0; windtest.ms2.data(end,1); windtest.ms4.data(end,1); windtest.ms6.data(end,1); windtest.ms8.data(end,1); ...
    windtest.ms10.data(end,1)];
ylandingPts = [ydata(end); windtest.ms2.data(end,2); windtest.ms4.data(end,2); windtest.ms6.data(end,2); windtest.ms8.data(end,2); ...
    windtest.ms10.data(end,2)];
xylandingDist = [ydata(end);sqrt(windtest.ms2.data(end,1)^2 + windtest.ms2.data(end,2)^2);sqrt(windtest.ms4.data(end,1)^2 + windtest.ms4.data(end,2)^2);...
    sqrt(windtest.ms6.data(end,1)^2 + windtest.ms6.data(end,2)^2);sqrt(windtest.ms8.data(end,1)^2 + windtest.ms8.data(end,2)^2);...
    sqrt(windtest.ms10.data(end,1)^2 + windtest.ms10.data(end,2)^2)];

windIncMatrix = [0;2;4;6;8;10];
xlandingPtsGain = polyfit(windIncMatrix,xlandingPts,1);
xylandingPtsGain = polyfit(windIncMatrix,xylandingDist,1);


figure() %plot different wind magnitude curves

plot3(zeros(size(ydata)),ydata,heightData,LineWidth=2)
hold on
plot3(windtest.ms2.data(:,1),windtest.ms2.data(:,2),-1*windtest.ms2.data(:,3),'c',LineWidth = 2)
plot3(windtest.ms4.data(:,1),windtest.ms4.data(:,2),-1*windtest.ms4.data(:,3),'r',LineWidth = 2)
plot3(windtest.ms6.data(:,1),windtest.ms6.data(:,2),-1*windtest.ms6.data(:,3),'b',LineWidth=  2)
plot3(windtest.ms8.data(:,1),windtest.ms8.data(:,2),-1*windtest.ms8.data(:,3),'g',LineWidth = 2)
plot3(windtest.ms10.data(:,1),windtest.ms10.data(:,2),-1*windtest.ms10.data(:,3),'m',LineWidth = 2)


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
legend('0 m/s magnitude wind','2 m/s magnitude wind','4 m/s magnitude wind','6 m/s magnitude wind',...
    '8 m/s magnitude wind','10 m/s magnitude wind','','','','','')
set(legend,...
    'Position',[0.528520833333334 0.688888888888889 0.3125 0.234523809523809]);
view([-43.300000061551 29.1718309828985]);
hold off
print("WithWind",'-r300','-dpng')





figure() %plot different wind magnitudes on x+z plot, to see change in landing position in x
hold on
plot(windtest.ms2.data(:,1),-1*windtest.ms2.data(:,3),LineWidth = 2)
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
plot(0,0,'^k',windIncMatrix(2),xlandingPts(2),'^k',windIncMatrix(3),xlandingPts(3),'^k',windIncMatrix(4),xlandingPts(4),'^k',...
    windIncMatrix(5),xlandingPts(5),'^k',windIncMatrix(6),xlandingPts(6),'^k',MarkerSize=8)

xlabel('Windspeed increased (m/s)')
ylabel('Distance defelected (m)')
title('Northern Deflection with North Wind Increase')
legend('Raw Deflection','Line of Best Fit','Landing Points','Location','northwest')
print("NorthLanding",'-r300','-dpng')


figure()
hold on
plot(windIncMatrix,xylandingDist,LineWidth = 2)
plot(windIncMatrix,xylandingPtsGain(1)*windIncMatrix + xylandingPtsGain(2),LineWidth = 2)
plot(windIncMatrix(1),xylandingDist(1),'^k',windIncMatrix(2),xylandingDist(2),'^k',windIncMatrix(3),xylandingDist(3),'^k',windIncMatrix(4),xylandingDist(4),'^k',...
    windIncMatrix(5),xylandingDist(5),'^k',windIncMatrix(6),xylandingDist(6),'^k',MarkerSize = 8)
title('Total Distance to Landing')
xlabel('Windspeed increased (m/s)')
ylabel('Distance defelected (m)')
legend('Raw Deflection','Line of Best Fit','Landing Points','Location','southwest')
print("xyLanding",'-r300','-dpng')

%% Functions
function xdot = objectEOM(t,x,rho,Cd,A,m,g,wind_vel)


%Inputs:
%t = time
%x = statevector, holding positions of x, y, and z, and derivatives
%(velocities) of each of those positions. Output of ODE45, not explicit in
%code.
%rho = atmospheric density = const.rho
%Cd = coefficient of drag = const.Cd
%A = cross sectional area = const.A
%m = mass = const.m
%g = gravitational acceleration = const.g
%wind_vel = background wind vector = [uw,vw,ww];

%Outputs:
%xdot: Derivative of the statevector

%Methodology:
%Use Accelerations from Newton's Second Law, as well as velocities, to
%populate the derivative of the statevector


vaMag = sqrt((x(4)-wind_vel(1))^2 + (x(5)-wind_vel(2))^2 + (x(6) - wind_vel(3))^2); %magitude of the airspeed vector

ue = x(4); %u component of the a/c velocity, m/s
ve = x(5); %v component of the a/c velocity, m/s
we = x(6); %w component of the a/c velocity, m/s

au = (-.5*rho*A*Cd*vaMag*(ue - wind_vel(1)))/m; %u component of the a/c acceleration, m/s^2
av = (-.5*rho*A*Cd*vaMag*(ve - wind_vel(2)))/m; %v component of the a/c acceleration, m/s^2
aw = (-.5*rho*A*Cd*vaMag*(we - wind_vel(1)))/m + g; %w component of the a/c acceleration, m/s^2


xdot = [ue; ve; we; au; av; aw;];%populate derivative of statevector



end


function  [value,isterminal,direction] = myEventFcn(t,x) 

%Event Function for ODE45

%Inputs:
%t = time (output of ode45)
%x = statevector (output of ode45

%Outputs:
%value: what value we want to equal 0
%isterminal: stop the integration
%direction: can approach zero from either side

%Methodology:
%Check the statevector value at every iteration to find where a value
%equals 0, and then stop the integration of ode45.


value = x(3);
isterminal = 1;
direction = 0;

end

function [const,initial] = getConst()
%inputs: none
%Outputs: constant and initial value structures
%Methodology:
%Define all constants and initial values, call them in script

const.Cd = .6; %nd
const.d = .02; %m
const.A = pi*(const.d/2)^2; %m^2
const.m = .050; %g
const.g = 9.8; %m/s^2
const.alt = 1655; %m
%Call Standard Atmosphere model to get density for 1655m (Boulder, CO)
[const.rho,~,~,~,~,~] = stdatmo(const.alt);%kg/m^3


initial.ue = 0; %m/s
initial.ve = 20; %m/s
initial.we = -20; %m/s

initial.windu = 0;%m/s
initial.windv = 0;%m/s
initial.windw = 0;%m/s

initial.t = 0;%sec

initial.xpos = 0;%m
initial.ypos = 0;%m
initial.zpos = 0;%m



end



