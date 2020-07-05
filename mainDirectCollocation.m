pkg load optim
pkg load control
clear all
close all
clc
    
%dbstop equalityConstraints 21
global N = 30;                  % number of collocation points
global initial_state = [-1; 0; pi; 0];  % [pos, vel, phi, omega]
global target_state = [1; 0; pi; 0];   % [pos, vel, phi, omega]
J = length(initial_state); 

% initial guess
t_guess = 1;
pos_guess = linspace(-1,1,N)';
vel_guess = (pos_guess(2)-pos_guess(1))/(t_guess/N) * ones(N,1);
phi_guess = linspace(pi,pi,N)';
omega_guess = (phi_guess(2)-phi_guess(1))/(t_guess/N) * ones(N,1);

u_guess = [10*ones(N/2,1);-10*ones(N/2,1)];

optim_vars_guess = [t_guess; pos_guess; vel_guess; phi_guess; omega_guess; u_guess];   

% bounds
t_lb = 0;   
t_ub = 4; 
pos_lb = -3 * ones(N, 1); 
pos_ub =  3 * ones(N, 1);
vel_lb = -100 * ones(N, 1); 
vel_ub =  100 * ones(N, 1);
phi_lb = -2*pi * ones(N, 1); 
phi_ub = 3*pi * ones(N, 1);
omega_lb = -100 * ones(N, 1); 
omega_ub =  100 * ones(N, 1);
u_lb = -20 * ones(N, 1); 
u_ub =  20 * ones(N, 1);
lb = [ t_lb; pos_lb; vel_lb; phi_lb; omega_lb; u_lb ];  
ub = [ t_ub; pos_ub; vel_ub; phi_ub; omega_ub; u_ub ];  

% solveroptions
maxIter = 1e3;
tol = 1e-5;

% inequality constraints
inequalityConstraints = []; 

% solve system
tic;
[sol, obj, info, iter, nf, lambda] = sqp(optim_vars_guess, @(optim_vars)objective(optim_vars),...
                     @(optim_vars)equalityConstraints(optim_vars), inequalityConstraints, lb, ub, maxIter, tol);
calc_time = toc

% print some info to the console
evalSolverString(info, iter, obj);

% build time vector for plots
sim_time = sol(1)
delta_time = sim_time / N;
times = 0 : delta_time : sim_time - delta_time;

% save data to use it in other scripts
save 'trajectoryData.m' 'sol'

% plotting, sol has structure: [sim_time, pos[1:N], vel[1:N], phi[1:N], omega[1:N], u[1:N]]
figure();
subplot(2,2,1);
plot(times, sol(2 : 1+N));
xlabel('Time (s)');
ylabel('pos (m)');
subplot(2,2,2);
plot(times, sol(2+N : 1+N*2));
xlabel('Time (s)');
ylabel('vel (m/s)');
subplot(2,2,3);
plot(times, sol(2+2*N : 1+N*3));
xlabel('Time (s)');
ylabel('phi (rad)');
subplot(2,2,4);
plot(times, sol(2+3*N : 1+N*4));
xlabel('Time (s)');
ylabel('omega (rad/s)');
figure();
plot(times, sol(2+N*4 : end));
xlabel('Time (s)');
ylabel('u (m/s^2)');