function [SR,Tp,GovPay] = CPIF_DAA_calcU(alpha,Ac,Tc,Cp)
% UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

SR=2*(2-alpha)*(1/3)

Tp = Cp - (3/2)*SR*(Tc - Ac)

GovPay = Ac + (Tp - Tc) + SR*(Tc - Ac)

end
