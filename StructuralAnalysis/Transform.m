syms beta p R t

T=[cos(beta) sin(beta);-sin(beta) cos(beta)];

sig=[(p*R)/(2*t) 0;0 (p*R)/t]

sigbar=T'*sig*T



