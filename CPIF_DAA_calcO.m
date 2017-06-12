function [SR,Tp,GovPay] = CPIF_DAA_calcO(beta,Ac,Tc,Cp,i,n_opt)
% solves for some optimal CPIF contract parameters
% called in CPIF_DAA_func.m

% inputs: beta (KTR profit control parameter), actual cost, target cost,
%         ceiling price, current KTR number, number of optimal bidders

% output: optimal sharing ratio, target price, government payment

%% --------------------------------------------------------------------- %%
% compute sharing ratio
if (i <= n_opt)
    SR = 1 - (4/3)*(1-beta)*(Cp-Ac)/(Ac-Tc);    % optimal SR
else
    SR = 0.5;                                   % non-optimal SR (must fix)
end

% compute target price
Tp = Cp - 1.5*SR*(Tc - Ac);

% compute government payment
GovPay = Ac + (Tp - Tc) + SR*(Tc - Ac);

end
