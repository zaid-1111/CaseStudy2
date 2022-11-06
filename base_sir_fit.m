clear




coviddata = load("COVIDdata.mat"); % TO SPECIFY
% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
pop = coviddata.STLmetroPop*1e5;
t = length(coviddata.COVID_STLmetro.cases); % TO SPECIFY
% t = 318 for mask mandate
coviddata = coviddata.COVID_STLmetro;

%% Data parsing to fit for different waves
coviddata2 = coviddata(1:134,:); % 07-18-2020
coviddata3 = coviddata(134:237,:); %10-29-2020
coviddata4 = coviddata(237:318,:); %01 - 18-2021
coviddata5 = coviddata(318:508,:);%07-27-2021
coviddata6 = coviddata(508:655,:);%12-21-2021
coviddata7 = coviddata(655:end,:);%05-13-2022

coviddata8 = coviddata(421:605,:); % Data for 5/1/21 – 11/1/21

t2 = length(coviddata2.date);
t3 = length(coviddata3.date);
t4 = length(coviddata4.date);
t5 = length(coviddata5.date);
t6 = length(coviddata6.date);
t7 = length(coviddata7.date);
t8 = length(coviddata8.date); % Correspoinding time for delta variant

%% Input data periods to plot here

%Note: Input data here for accurate plots

Inputtime = t8;        %Input time here
InputData = coviddata8; %Input data here

Policy = false; %Set to true to implement policy

sirafun= @(x)siroutput(x,Inputtime,InputData);

%% set up rate and initial condition constraints
% Set A and b to impose a parameter inequality constraint of the form A*x < b
% Note that this is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
A = [0 0 1 0 0 0 0 0 0 0];
b = [A(1)];

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Hint: For example, the sum of the initial conditions should be
% constrained
% If you don't want such a constraint, keep these matrices empty.
Af = ([0,0,0,1,1,1,1,0,0,0]);
bf = 1;

%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.

ub = [1 1 1 1 1 1 1 1 1 1];
lb = [0 0 0 0 0 0 0 0 0 0];

% Specify some initial parameters for the optimizer to start from
x0 = [0.0001    0.0000    0.0010    1.0000    0.000    0.000    0.001    0.4643    0.4643    0.4643]; 


x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);

if Policy
x(1) = 0.75*(x(1));%First policy trial: Reduce infection rate by 25%
x(3) = 1.05*(x(3));%Increased recovery rate due to reduced workloads at hospitals
end

Y_fit = siroutput_full(x,Inputtime);
hold on
Simcases = pop - Y_fit(:,1)*pop; %Simulation cases
Simdeaths = Y_fit(:,4).*pop;    %Simulation deaths



% Make some plots that illustrate your findings.

plot(InputData.date,InputData.deaths,'b');
hold on
plot(InputData.date,Simdeaths,'r','LineWidth',1);
legend('Deaths data', 'Simulated deaths')
title("")
xlabel('date')
ylabel('Number of cases to date')

