syms k lam 

p= - k/2 - (-(k + 2*lam - 1)*(2*lam - k + 1))^(1/2)/2 - 1/2

D=(-(k + 2*lam - 1)*(2*lam - k + 1))^.5

solve(D,lam)

k=2
lam= 1;

What= ((-(k + 2*lam - 1).*(2*lam - k + 1)).^(1/2)/2 - k/2 - 1/2)