function [] = CPIF_DAA_func(Oc,Tc,Pc,Cp,n,n_opt,mode)
% calculates optimal contract parameters for Cost Plus Incentive Fee

% inputs: optimistic cost, target cost, pessimistic cost, ceiling price,
%         number of contractors, number who bid optimally

% optional input: if there are 7 arguments, uses triangular distribution
%                 with mode equal to target cost (default is uniform dist)

% output: average optimum government payment, target price, sharing ratio,
%         target fee, max/min fee, adjustment formula, and initial profit
%         conditions for under- and over-run cases
 
% initialize
m = 5000;   % number of iterations

%% Under-run case %%

% initialize averages
avgSR = 0;
avgTp = 0;
avgGovPay = 0;
avgAc = 0;

% iteration loop
for k = 1:m
    % initialize parameter storage
    Ac = zeros(n,1);
    alpha = zeros(n,1);
    SR = zeros(n,1);
    Tp = zeros(n,1);
    GovPay = zeros(n,1);
    
    % contractor loop to solve for optimal parameters
    for i = 1:n
        % randomly generate actual cost according to triangular or uniform dist
        if (nargin == 7)
            test = true;
            while test
                Ac(i) = triangle_Cost(Oc,Pc,mode);
                test = (Ac(i) > Tc);
            end
        else
            Ac(i) = Oc + (Tc-Oc)*rand;
        end
        
        % randomly generate government savings control parameter
        alpha(i) = 0.5 + (2-0.5)*rand;
    
        % calculate optimal contract parameters
        [SR(i),Tp(i),GovPay(i)] = CPIF_DAA_calcU(alpha(i),Ac(i),Tc,Cp,i,n_opt);
    end
    
    % select winning contrator
    [~,index] = min(GovPay);
    
    % update averages
    avgSR = avgSR + SR(index);
    avgTp = avgTp + Tp(index);
    avgGovPay = avgGovPay + GovPay(index);
    avgAc = avgAc + Ac(index);
end

% calculate averages
avgSR_U = avgSR./m;
avgTp_U = avgTp./m;
avgGovPay_U = avgGovPay./m;
avgAc = avgAc./m;

% calculate other contract parameters
avgFt_U = avgTp_U - Tc;
avgFmax = avgSR_U.*(Tc-Oc) + avgFt_U;
avgFunder = avgSR_U.*(Tc-avgAc) + avgFt_U;
avgalpha = 2 - (1.5).*avgSR_U;
PCFU_G_0 = avgalpha.*(Tc-avgAc);
PCFU_K_0 = Cp-Tc;

%% Over-run case %%

% initialize averages
avgSR = 0;
avgTp = 0;
avgGovPay = 0;
avgAc = 0;

% iteration loop
for k = 1:m
    % initialize parameter storage
    Ac = zeros(n,1);
    beta = zeros(n,1);
    SR = zeros(n,1);
    Tp = zeros(n,1);
    GovPay = zeros(n,1);
    
    % contractor loop to solve for optimal parameters
    for i = 1:n
        % randomly generate actual cost
        if (nargin == 7)
            test = true;
            while test
                Ac(i) = triangle_Cost(Oc,Pc,mode);
                test = (Ac(i) < Tc);
            end
        else
            Ac(i) = Tc + (Pc-Tc)*rand;
        end
        
        % randomly generate contractor profit control parameter
        low = 1 - 0.75*(Ac(i)-Tc)/(Cp-Ac(i));
        beta(i) = low + (1-low)*rand;
    
        % calculate optimal contract parameters
        [SR(i),Tp(i),GovPay(i)] = CPIF_DAA_calcO(beta(i),Ac(i),Tc,Cp,i,n_opt);
    end
    
    % select winning contrator
    [~,index] = min(GovPay);
    
    % update averages
    avgSR = avgSR + SR(index);
    avgTp = avgTp + Tp(index);
    avgGovPay = avgGovPay + GovPay(index);
    avgAc = avgAc + Ac(index);
end

% calculate averages
avgSR_O = avgSR./m;
avgTp_O = avgTp./m;
avgGovPay_O = avgGovPay./m;
avgAc = avgAc./m;

% calculate other contract parameters
avgFt_O = avgTp_O - Tc;
avgFmin = avgFt_O - avgSR_O.*(Pc-Tc);
avgFover = avgFt_O - avgSR_O.*(Pc-avgAc);
avgbeta = 1 - (0.75).*(avgAc-Tc).*(1-avgSR_U)./(Cp-avgAc);
PCFO_G_0 = 0;
PCFO_K_0 = avgbeta.*(Cp-avgAc);

%% Display Output %%

% output for under-run case
fprintf(['\n'])
disp(['The average government payment for the under-run case is ' num2str(avgGovPay_U) '.']) 
disp(['The average optimum target price for the under-run case is ' num2str(avgTp_U) '.'])
disp(['The average optimum sharing ratio for the under-run case is ' num2str(avgSR_U) '.'])
disp(['The average optimum target fee for the under-run case is ' num2str(avgFt_U) '.'])
disp(['The average optimum maximum fee is ' num2str(avgFmax) '.'])
disp(['The adjustment formula for calculating the optimum fee for the under-run case is F_under = ' num2str(avgSR_U) '*(' num2str(Tc) '-Ac) + ' num2str(avgFt_U) '.'])
disp(['The optimum initial condition for government savings in the under-run case is ' num2str(PCFU_G_0) '.'])
disp(['The optimum initial condition for contractor profit in the under-run case is ' num2str(PCFU_K_0) '.'])
    
% output for over-run case
fprintf(['\n'])
disp(['The average government payment for the over-run case is ' num2str(avgGovPay_O) '.'])
disp(['The average optimum target price for the over-run case is ' num2str(avgTp_O) '.'])
disp(['The average optimum sharing ratio for the over-run case is ' num2str(avgSR_O) '.'])
disp(['The average optimum target fee for the over-run case is ' num2str(avgFt_O) '.'])
disp(['The average optimum minimum fee is ' num2str(avgFmin) '.'])
disp(['The adjustment formula for calculating the optimum fee for the over-run case is F_over = ' num2str(avgFt_O) ' - ' num2str(avgSR_O) '*(' num2str(Pc) '-Ac).'])
disp(['The optimum initial condition for government savings in the over-run case is ' num2str(PCFO_G_0) '.'])
disp(['The optimum initial condition for contractor profit in the over-run case is ' num2str(PCFO_K_0) '.'])
fprintf(['\n'])
    
end
