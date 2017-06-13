function [SR,Tp,GovPay,profit,GovS] = CPIF_DAA_calcU(alpha,Ac,Oc,Tc,Pc,Cp,i,n_opt,exProf)
% solves for some optimal CPIF contract parameters
% called in CPIF_DAA_func.m

% inputs: alpha (gov savings control parameter), actual cost, optimistic
%         cost, target cost, pessimistic cost, ceiling price, current KTR 
%         number, number of optimal bidders, expected profit

% output: optimal sharing ratio, target price, government payment,
%         contractor profit, government savings

%% --------------------------------------------------------------------- %%
% compute sharing ratio
if (i <= n_opt)
    SR = 2*(2-alpha)*(1/3);                 % optimal SR
else
    SR = KTR_Share(exProf,Oc,Tc,Pc,Cp);
    SR = SR(1);                             % non-optimal SR (must fix)
end

% compute target price
Tp = Cp-1.5*SR*(Tc-Ac);

% compute government payment
GovPay = Ac+(Tp-Tc)+SR*(Tc-Ac);

% compute contractor profit
profit = (Tp-Tc)+SR*(Tc-Ac);

% compute government savings
GovS = Cp+(1-SR)*(Tc-Ac)-GovPay;

end
