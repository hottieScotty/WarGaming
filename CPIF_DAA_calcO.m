function [SR,Tp,GovPay,profit,GovS] = CPIF_DAA_calcO(beta,Ac,Tc,Cp,i,n_opt)
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

%{
%compute government savings and profit
PGO = -Cp; % from slides, note as different than above case
    PKO = Cp-Ac;
    PGF = @(s) Ac + (Tp - Tc) - s*(Ac - Tc); % each flips ac tc and uses overun share
    PKF = @(s) (Tp - Tc)+(1-s)*(Ac - Tc);
    PK = @(s) (1-s)*(Ac - Tc);

PG = @(s) 2*(1-s)*(Tc-Ac)-Tp; %one payoff gov function for optimization

toMin = @(s) -(PG(s)-PGO)*(PK(s)-PKO); %minimizes negative of optimzation function from slides

sRO = fminbnd(toMin, 0, 1);%matlab function which minimizes

PCFG = PGF(sRO); %returns final payoff based on final payoff functions
%}

profit = (Tp - Tc) + (1-SR)*(Ac - Tc);

GovS = Cp+(1-SR)*(Tc-Ac) - GovPay;


end
