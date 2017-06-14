function [SR,Tp,GovPay,profit,GovS] = CPIF_DAA_calcO(beta,Ac,Oc,Tc,Pc,Cp,i,n_opt,exProf)
% solves for some optimal CPIF contract parameters
% called in CPIF_DAA_func.m

% inputs: beta (gov savings control parameter), actual cost, optimistic
%         cost, target cost, pessimistic cost, ceiling price, current KTR 
%         number, number of optimal bidders, expected profit

% output: optimal sharing ratio, target price, government payment,
%         contractor profit, government savings

%% --------------------------------------------------------------------- %%
% compute sharing ratio
if (i <= n_opt)
    SR = 1-(4/3)*(1-beta)*(Cp-Ac)/(Ac-Tc);      % optimal SR
else
    SR = KTR_Share(exProf,Oc,Tc,Pc,Cp);
    SR = SR(2);                                 % non-optimal SR (must fix)
end

% compute target price
Tp = Cp-1.5*(1-SR)*(Tc-Ac);

% compute government payment
GovPay = Ac+(Tp-Tc)+SR*(Tc-Ac);

% compute contractor profit
profit = (Tp-Tc)+(1-SR)*(Ac-Tc);

% compute government savings
GovS = Cp+(1-SR)*(Tc-Ac)-GovPay;

end
