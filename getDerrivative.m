function xd = getDerrivative(x, u)
  
  m1 = 1;          % mass of the cart
  m2 = 0.5;        % mass of the pole
  l = 1.7;           % length of the pole
  g = 9.81;        % earth gravity
  d1 = 0.1;        % viscous friction on the cart 
  d2 = 0.01;       % viscous friction on the pole 
  
  
  % differential equation of inverted pendulum
  xd(1) = x(2);
  xd(2) = -(l*(d1*x(2) + l*m2*x(4)^2*sin(x(3)) - u) + (d2*x(4) - g*l*m2*sin(x(3)))*cos(x(3)))/(l*(m1 + m2*sin(x(3))^2));
  xd(3) = x(4);
  xd(4) = -(l*m2*(d1*x(2) + l*m2*x(4)^2*sin(x(3)) - u)*cos(x(3)) + (m1 + m2)*(d2*x(4) - g*l*m2*sin(x(3))))/(l^2*m2*(m1 + m2*sin(x(3))^2));
  xd = xd';
  
endfunction
