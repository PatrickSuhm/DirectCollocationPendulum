function phi = objective(optim_vars)
  
  global N; 
  
  phi = optim_vars(1);   % minimize time
  
  %phi = optim_vars(2+N*4 : end)' * optim_vars(2+N*4 : end);   % minimize control energy
  
end