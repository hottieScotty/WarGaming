function [SR,Tp,GovPay] = CPIF_DAA_calcU(alpha,Ac,Tc,Cp,i,n_opt)
% solves for some optimal CPIF contract parameters
% called in CPIF_DAA_func.m

% inputs: alpha (gov savings control parameter), actual cost, target cost,
%         ceiling price, current KTR number, number of optimal bidders

% output: optimal sharing ratio, target price, government payment

%% --------------------------------------------------------------------- %%
% compute sharing ratio
if (i <= n_opt)
    SR = 2*(2-alpha)*(1/3);     % optimal SR
else
    SR = 0.5;                   % non-optimal SR (must fix)
end

% compute target price
Tp = Cp - 1.5*SR*(Tc - Ac);

% compute government payment
GovPay = Ac + (Tp - Tc) + SR*(Tc - Ac);

end
