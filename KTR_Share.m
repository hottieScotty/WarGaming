function [SRi] = KTR_Share(profit_rate,Oc,Tc,Pc,Cp)
% takes initial guess at optimal sharing ratio based on expected profit

% inputs: expected profit rates, optimistic cost, target cot, pessimistic
%         cost, ceiling price

% output: sharing ratios based on expected profit; first value is for
%         under-run case, second is for over-run case

%% --------------------------------------------------------------------- %%
% target profit
PFtc=Tc*profit_rate(1,1:2)./100;    % convert to percentage

% optimistic profit
PFoc=Oc*profit_rate(1,3:4)./100;    % convert to percentage

% pessimistic profit
PFpta=Cp-Pc;

% under-run share ratios
ShareRatio(1:2)=(PFoc-PFtc)./(Tc-Oc);
SRi(1)=(ShareRatio(1)+ShareRatio(2))/2;

% over-run share ratios
ShareRatio(3:4)=(PFtc-PFpta)./(Pc-Tc);
SRi(2)=(ShareRatio(3)+ShareRatio(4))/2;

end
