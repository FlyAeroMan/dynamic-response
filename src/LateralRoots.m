function latRoots = LateralRoots(allData)
%LateralRoots - a function that expresses the Lateral equations of motion
%of an aircraft in state space form, then takes the eigen values of the A
%matrix to determine the roots of the polynomial.

% retrieve required values from alldata
% Aircraft data
q = ; % dynamic pressure (lbf/in^2)
S = ; % Wing area (in^2)
m = ; % mass (slugs)
b = ; % wing span (in)
u1 = ; % Vinf, steady state velocity (in/s)
g = ; % gravitational constant (in/s^2)

% Y Force non-dimensional derivatives
Cyb = ;
Cyp = ;
Cyr = ;
Cyda = ;

% Rolling Moment non-dimensional derivatives
Clb = ;
Clp = ;
Clr = ;
Clda = ;

% Yawing Moment non-dimensional derivatives
Cnb = ;
CnTb = ;
Cnp = ;
Cnr = ;
Cnda = ;

% Moments of Inertia in the Body Fixed Axis
IxxB = ;
IzzB = ;
IxzB = ;
Ibody = [IxxB, IzzB, IxzB];

% calculate inertia in stability axis
SteadyStateAngleOfAttack = ;%deg
Itransform = [];
Istability = Itransform*Ibody;
IxxS = Istability(1);
IzzS = Istability(2);
IxzS = Istability(3);

% calculate dimensional derivatives
% Y Force dimensional derivatives
Yb = q*S*Cyb/m; % (in/sec^2)/rad
Yp = q*S*Cyp/(2*m*u1); % (in/sec^2)/(rad/sec)
Yr = q*S*Cyr/(2*m*u1); % (in/sec^2)/(rad/sec)
Yda = q*S*Cyda/m; % (in/sec^2)/rad

% Rolling Moment dimensional derivatives
Lb = q*S*b*Clb/IxxS; % (rad/sec^2)/rad
Lp = q*S*b^2*Clp/(2*IxxS*u1); % (rad/sec^2)/(rad/sec)
Lr = q*S*b^2*Clr/(2*IxxS*u1); % (rad/sec^2)/(rad/sec)
Lda = q*S*b*Clda/IxxS; % (rad/sec^2)/rad

% Yawing Moment dimensional derivatives
Nb = q*S*b*Cnb/IzzS;
NTb = q*S*b*CnTb/IzzS;
Np = q*S*b^2*Cnp/(2*IzzS*u1);
Nr = q*S*b^2*Cnr/(2*IzzS*u1);
Nda = q*S*b*Cnda/IzzS;

% Setup the A matrix
Ip = (IxzS*IzzS)/(IxxS*IzzS-IxzS^2);
Ir = (IxzS*IxxS)/(IxxS*IzzS-IxzS^2);
A = [
Yb/u1, Yp/u1, (Yr-u1)/u1, g*cos(theta1)/u1
Ip*Lb*(Nb+NTb), Ip*Lp*Np, Ip*Lr*Nr, 0
Ir*Lb*(Nb+NTb), Ir*Lp*Np, Ir*Lr*Nr, 0
0, 1, 0, 0
];

% retrieve eigen values of A matrix & store eigen values in latRoots
latRoots = eig(A);
end