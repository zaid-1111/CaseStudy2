%%  This function takes three inputs
% x - a set of parameters
% t - the number of time-steps you wish to simulate
% data - actual data that you are attempting to fit

function f = siroutput2(x,t,data)
% set up transmission constants
k_infections = x(1);
k_fatality = x(2);
k_recover = x(3);
k_vax = x(4);% Added vaccine constant
k_BT = x(5);% Added breakthrough infection constant
% set up initial conditions
ic_susc = x(6);
ic_inf = x(7);
ic_rec = x(8);
ic_fatality = x(9);
ic_vax = x(10); %IC for vaccination
ic_BT = x(11); %IC for breakthrough cases
% Set up SIRD within-population transmission matrix
A = [1-k_infections-k_vax,  0,0,0,0,0;                   %Assumes that recovered people are immune
    k_infections, (1-k_fatality - k_recover), 0 ,0,0,0; 
    0, k_recover, 1-k_vax, 0,0,   0;                     % Assumes recovery is only happening to those who got infected
    0, k_fatality,0,1,0,    0;
    k_vax,0,k_vax,0,1-k_BT,k_recover;
    0,0,0,0,k_BT,          1-k_recover;];                  
% The next line creates a zero vector that will be used a few steps.
B = zeros(6,1);

% Set up the vector of initial conditions
x0 = [ic_susc ic_inf ic_rec ic_fatality ic_vax ic_BT];
% Here is a compact way to simulate a linear dynamical system.
% Type 'help ss' and 'help lsim' to learn about how these functions work!!
sys_sir_base = ss(A,B,eye(6),zeros(6,1),1);
y = lsim(sys_sir_base,zeros(t,1),linspace(0,t-1,t),x0);

symInf = y(:,2) + y(:,6); %Infections
 
casedist = (symInf - data.InfectedProportion).^2;
deathdist = (y(:,4) -  data.cumulativeDeaths).^2;
cost = norm([casedist , deathdist]);

f = cost;
end
