function ceq = equalityConstraints(optim_vars)
    
    global N;   
    global initial_state;
    global target_state;
  
    % Calculate the timestep
    delta_time = optim_vars(1) / N;   % optim_vars(1) ist die Endzeit des letzten Durchlaufs
    
    % Get the states and inputs out of the optim_vars (state is then (N,J) matrix)
    state = [optim_vars(2 : 1+N), optim_vars(2+N : 1+N*2), optim_vars(2+N*2 : 1+N*3), optim_vars(2+N*3 : 1+N*4)];   
    u     = optim_vars(2+N*4 : end);
    
    % Constrain first state to be initial_state
    ceq = initial_state - state(1,:)';
    
    % this loop appends length of the state vector to the ceq vector for every cycle
    for k = 1 : length(state(:,1)) - 1
        
        % The time derivative of the state at the start and end of the time interval
        f_k = getDerrivative(state(k,:), u(k));
        f_k_plus_1 = getDerrivative(state(k+1,:), u(k+1));
        
        % The end state of the time interval calculated using quadrature
        x_k_plus_1_quad = state(k,:)' + delta_time * 0.5 * (f_k + f_k_plus_1);
        
        % Constrain the end state of the current time interval to be
        % equal to the starting state of the next time interval
        ceq = [ceq ; state(k+1,:)' - x_k_plus_1_quad];
    end
    
    % Constrain last state to be targe_state
    ceq = [ceq ; target_state - state(end,:)'];
    
endfunction