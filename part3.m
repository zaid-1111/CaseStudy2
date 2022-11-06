
Tdata = load('mockdata_v2.mat');

%% NOTE:
% The way we plot is by selecting parsed data 1 by 1 and just hitting run.
% This helps us adjust the parameters between different sets of data for
% testing purposes. We can also use this to isolate different segments and
% plot individually. This design choice for code was purposeful

Data1.cumulativeDeaths = Tdata.cumulativeDeaths(1:100);
Data1.InfectedProportion = Tdata.InfectedProportion(1:100);
Data2.cumulativeDeaths = Tdata.cumulativeDeaths(101:end);
Data2.InfectedProportion = Tdata.InfectedProportion(101:end);


InputData = Data1;
Inputtime = length(Data1.InfectedProportion);


sirafun= @(x)siroutput2(x,Inputtime,InputData);

%% set up rate and initial condition constraints
% Set A and b to impose a parameter inequality constraint of the form A*x < b
% Note that this is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
A = [1 1 1 1 1 0 0 0 0 0 0];
b = 1;

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Hint: For example, the sum of the initial conditions should be
% constrained
% If you don't want such a constraint, keep these matrices empty.
Af = ([0,0,0,0,0,1,1,1,1,1,1]);
bf = 1;

%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.

%  ub = [0.1 0.1 0.1 0.017955 0.1 1     1 1 1 0 0]; % Constraints for after 100 days
%  lb = [0 0 0 0 0 0 0 0 0 0     0];

 ub = [0.01 1 1 0 1 1 1     1 1 0 0]; % Constraints till 100 days
 lb = [0 0 0 0 0 1 0 0 0 0     0];

% Specify some initial parameters for the optimizer to start from
x0 = [0.0001 0 0.0010 0.00 0 1 0.01 0.1 0 0 0]; 

x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);
Y_fit = siroutput_full2(x,Inputtime);
simInf = Y_fit(:,2) + Y_fit(:,6);
simDeaths = Y_fit(:,4);
hold on
% plot(Tdata.InfectedProportion);
% % plot(simInf)
% %plot(transpose(101:365),simInf);
% title('Simulation and data: Infected Proportion')
% xlabel('Days')
% ylabel('Infected Proportion')



plot(Tdata.cumulativeDeaths)

plot(simDeaths)
% plot(transpose(101:365),simDeaths);
title('Simulation and data: Cumulative Deaths')
xlabel('Days')
ylabel('cumulative deaths')

