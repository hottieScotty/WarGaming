function [] = CPIF_DAA_func(Oc,Tc,Pc,Cp,n,n_opt,tri)
% calculates optimal contract parameters for Cost Plus Incentive Fee

% inputs: optimistic cost, target cost, pessimistic cost, ceiling price,
%         number of contractors, number who bid optimally

% optional input: if there are 7 arguments, uses triangular distribution
%                 with mode equal to target cost (default is uniform dist)

% output: average optimum government payment, target price, sharing ratio,
%         target fee, max/min fee, adjustment formula, and initial profit
%         conditions for under- and over-run cases

% Initialize
m = 5000;   % number of iterations

%% Loop for under-run case %%
for k = 1:m
    % randomly generate actual cost according to triangular or uniform dist
    if (nargin == 7)
        Ac = triangle_Cost(Oc,Tc,Tc,n);
    else
        Ac = Oc + (Tc-Oc).*rand(n,1);
    end
    % randomly generate alpha 
    
    % Contrator loop
    for i = 1:n
        
    end
end

end
