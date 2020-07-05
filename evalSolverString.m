function evalSolverString(info, iter, obj)
  
  switch(info)
  case 101
    disp("Sqp: good solution found.");
  case 102
    disp("Sqp: BFGS update failed");
  case 103
    disp("Sqp: maxIter reached");
  case 104
    disp("Sqp: stepsize to small");
  otherwise
    disp("Sqp: unspecified return value");
  endswitch
  iter  % output iter
  obj   % output value of objective function
  
endfunction
