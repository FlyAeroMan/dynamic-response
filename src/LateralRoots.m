function [latRoots,RollControlEffectivness,Tr] = LateralRoots(alldata, controls)
%LateralRoots - a function that expresses the Lateral equations of motion
%of an aircraft in state space form, then takes the eigen values of the A
%matrix to determine the roots of the polynomial.

% retrieve required values from alldata
% Aircraft data
q = alldata{1}(8); % dynamic pressure (lbf/in^2)
S = alldata{1}(1); % Wing area (in^2)
m = alldata{1}(3); % mass (slugs)
b = alldata{1}(2); % wing span (in)
u1 = alldata{1}(5); % Vinf, steady state velocity (in/s)
g = alldata{1}(6); % gravitational constant (in/s^2)

% Y Force non-dimensional derivatives
Cyb = alldata{3}(1);
Cyp = alldata{3}(2);
Cyr = alldata{3}(3);
if controls
    Cyda = alldata{3}(4);
end

% Rolling Moment non-dimensional derivatives
Clb = alldata{4}(1);
Clp = alldata{4}(2);
Clr = alldata{4}(3);
if controls
    Clda = alldata{4}(4);
end

% Yawing Moment non-dimensional derivatives
Cnb = alldata{5}(1);
CnTb = alldata{5}(2);
Cnp = alldata{5}(3);
Cnr = alldata{5}(4);
if controls
    Cnda = alldata{5}(5);
end

% Moments of Inertia in the Body Fixed Axis
IxxB = alldata{2}(1);
IzzB = alldata{2}(2);
IxzB = alldata{2}(3);
Ibody = [IxxB; IzzB; IxzB];

% calculate inertia in stability axis
SSAOA = alldata{1}(9); % Steady State Angle of Attack (deg)
Itransform = [cosd(SSAOA)^2, sind(SSAOA)^2, -sind(2*SSAOA)
              sind(SSAOA)^2, cosd(SSAOA)^2, sind(2*SSAOA)
              0.5*sind(2*SSAOA), -0.5*sind(2*SSAOA), cosd(2*SSAOA)];
Istability = Itransform*Ibody;
IxxS = Istability(1);
IzzS = Istability(2);
IxzS = Istability(3);

% calculate dimensional derivatives
% Y Force dimensional derivatives
Yb = q*S*Cyb/m; % (in/sec^2)/rad
Yp = q*S*Cyp/(2*m*u1); % (in/sec^2)/(rad/sec)
Yr = q*S*Cyr/(2*m*u1); % (in/sec^2)/(rad/sec)
if controls
    Yda = q*S*Cyda/m; % (in/sec^2)/rad
end

% Rolling Moment dimensional derivatives
Lb = q*S*b*Clb/IxxS; % (rad/sec^2)/rad
Lp = q*S*b^2*Clp/(2*IxxS*u1); % (rad/sec^2)/(rad/sec)
Lr = q*S*b^2*Clr/(2*IxxS*u1); % (rad/sec^2)/(rad/sec)
if controls
    Lda = q*S*b*Clda/IxxS; % (rad/sec^2)/rad
end

% Yawing Moment dimensional derivatives
Nb = q*S*b*Cnb/IzzS;
NTb = q*S*b*CnTb/IzzS;
Np = q*S*b^2*Cnp/(2*IzzS*u1);
Nr = q*S*b^2*Cnr/(2*IzzS*u1);
if controls
    Nda = q*S*b*Cnda/IzzS;
end

% Setup the A matrix
Ip = (IxzS*IzzS)/(IxxS*IzzS-IxzS^2);
Ir = (IxzS*IxxS)/(IxxS*IzzS-IxzS^2);
theta1 = SSAOA; % assuming zero flight path angle, stability axis aligned with flight path
A = [
Yb/u1, Yp/u1, (Yr-u1)/u1, g*cosd(theta1)/u1
Ip*Lb*(Nb+NTb), Ip*Lp*Np, Ip*Lr*Nr, 0
Ir*Lb*(Nb+NTb), Ir*Lp*Np, Ir*Lr*Nr, 0
0, 1, tand(theta1), 0
];

% retrieve eigen values of A matrix & store eigen values in latRoots
latRoots = eig(A);
if controls
    % Calculates roll control effectivness
    t = 0;
    bank = 0;
    bankattime = 0;
    while bank < 60*(pi/180)
        bank = -((Lda*12*(pi/180))/(Lp))*t+((Lda*12*(pi/180))/(Lp^2))*(exp(Lp*t)-1);
        if t > 1.144 && t < 1.146
            bankattime = bank;
            time = t;
        end
        t = t + 0.001;
    end
    RollControlEffectivness = [t,bank*(180/pi),bankattime*(180/pi),time];
    
    % Calculate roll mode time constant
    Tr = -1/Lp;
else
    RollControlEffectivness = 0;
    Tr = 0;
end
end