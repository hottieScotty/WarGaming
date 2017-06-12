function [SR,Tp,GovPay,profit,GovS] = CPIF_DAA_calcU(alpha,Ac,Tc,Cp,i,n_opt)
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

%{
%compute Profit and Government Savings
    PGO = (2*(Tc-Ac) - Cp); %benchmark payoff gov and payoff ktr, from slides
    PKO = (Tp-Tc);
    PGF = @(s) Ac + (Tp - Tc) + s*(Tc - Ac); %final (positive) payoff gov function
    PKF = @(s) (Tp - Tc)+(s)*(Tc - Ac); %final payoff function ktr
    PK = @(s) (s)*(Tc - Ac); %payoff function for maximzation

PG = @(s) 2*(1-s)*(Tc-Ac)-Tp; %one payoff gov function for optimization

toMin = @(s) -(PG(s)-PGO)*(PK(s)-PKO); %minimizes negative of optimzation function from slides

sRO = fminbnd(toMin, 0, 1); %matlab function which minimizes

PCFG = PGF(sRO); %returns final payoff based on final payoff functions
%}

profit = (Tp - Tc)+SR*(Tc - Ac);

GovS = Cp+(1-SR)*(Tc-Ac)-GovPay;

end
