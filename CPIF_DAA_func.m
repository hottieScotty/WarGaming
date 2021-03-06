function [] = CPIF_DAA_func(Oc,Tc,Pc,Cp,n,n_opt,mode)
% calculates optimal contract parameters for Cost Plus Incentive Fee

% inputs: optimistic cost, target cost, pessimistic cost, ceiling price,
%         number of contractors, number who bid optimally

% optional input: if there are 7 arguments, uses triangular distribution
%                 with mode equal to 'mode' (default is uniform dist)

% output: average optimum government payment, target price, sharing ratio,
%         target fee, max/min fee, adjustment formula, and initial profit
%         conditions for under- and over-run cases

%% Initialize %%

% simulation settings
m = 5000;               % number of iterations
shouldPlot = 1;         % plots if 1; does not if 0

if (shouldPlot)
    % running averages for under-run case
    plotGP_U = zeros(n,m);  
    plotSR_U = zeros(n,m);
    plotProf_U = zeros(n,m);
    plotGS_U = zeros(n,m);
    plotFt_U = zeros(n,m);
    plottotalP_U = zeros(n,m);

    % running averages for over-run case
    plotGP_O = zeros(n,m);  
    plotSR_O = zeros(n,m);
    plotProf_O = zeros(n,m);
    plotGS_O = zeros(n,m);
    plotFt_O = zeros(n,m);
    plottotalP_O = zeros(n,m);
    totalP = zeros(n,1);
    avgWins = zeros(n,1);
end
    
% calculate expected profit based on industry factors
%exProf = Ex_Profit_Calc();
exProf = [10 8.75 15 13.75];

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
    Prof = zeros(n,1);
    GovSav = zeros(n,1);
    
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
        [SR(i),Tp(i),GovPay(i),Prof(i),GovSav(i)] = CPIF_DAA_calcU(alpha(i),Ac(i),Oc,Tc,Pc,Cp,i,n_opt,exProf);
    end
    
    % update running averages
    if (shouldPlot)
        if (k == 1)
            plotGP_U(:,k) = plotGP_U(:,k) + GovPay;
            plotSR_U(:,k) = plotSR_U(:,k) + SR;
            plotProf_U(:,k) = plotProf_U(:,k) + Prof;
            plotGS_U(:,k) = plotGS_U(:,k) + GovSav;
        else
            plotGP_U(:,k) = (k-1).*plotGP_U(:,k-1) + GovPay;
            plotSR_U(:,k) = (k-1).*plotSR_U(:,k-1) + SR;
            plotProf_U(:,k) = (k-1).*plotProf_U(:,k-1) + Prof;
            plotGS_U(:,k) = (k-1).*plotGS_U(:,k-1) + GovSav;
        end
        plotGP_U(:,k) = plotGP_U(:,k)./k;
        plotSR_U(:,k) = plotSR_U(:,k)./k;
        plotProf_U(:,k) = plotProf_U(:,k)./k;
        plotGS_U(:,k) = plotGS_U(:,k)./k;
    end
    
    % select winning contrator and update profit
    [~,index] = min(GovPay);
    if (shouldPlot)
        totalP(index) = totalP(index) + Prof(index);
        plottotalP_U(:,k)= totalP;
        avgWins(index) = avgWins(index) + 1;
    end
    
    % update averages for winning contract
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
totalP = zeros(n,1);

% iteration loop
for k = 1:m
    % initialize parameter storage
    Ac = zeros(n,1);
    beta = zeros(n,1);
    SR = zeros(n,1);
    Tp = zeros(n,1);
    GovPay = zeros(n,1);
    Prof = zeros(n,1);
    GovSav = zeros(n,1);
    
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
        [SR(i),Tp(i),GovPay(i),Prof(i),GovSav(i)] = CPIF_DAA_calcO(beta(i),Ac(i),Oc,Tc,Pc,Cp,i,n_opt,exProf);
    end
    
    % update running averages
    if (shouldPlot)
        if (k == 1)
            plotGP_O(:,k) = plotGP_O(:,k) + GovPay;
            plotSR_O(:,k) = plotSR_O(:,k) + SR;
            plotProf_O(:,k) = plotProf_O(:,k) + Prof;
            plotGS_O(:,k) = plotGS_O(:,k) + GovSav;

        else
            plotGP_O(:,k) = (k-1).*plotGP_O(:,k-1) + GovPay;
            plotSR_O(:,k) = (k-1).*plotSR_O(:,k-1) + SR;
            plotProf_O(:,k) = (k-1).*plotProf_O(:,k-1) + Prof;
            plotGS_O(:,k) = (k-1).*plotGS_O(:,k-1) + GovSav;
        end
        plotGP_O(:,k) = plotGP_O(:,k)./k;
        plotSR_O(:,k) = plotSR_O(:,k)./k;
        plotProf_O(:,k) = plotProf_O(:,k)./k;
        plotGS_O(:,k) = plotGS_O(:,k)./k;
        plottotalP_O(:,k)= plotProf_O(:,k).*k;
    end
    
    % select winning contrator and update profit
    [~,index] = min(GovPay);
    if (shouldPlot)
        totalP(index) = totalP(index) + Prof(index);
        plottotalP_O(:,k)= totalP;
        avgWins(index) = avgWins(index) + 1;
    end
    
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

%% Plot Averages %%

if (shouldPlot)
    % average under- and over-run cases
    plotGP = (plotGP_U + plotGP_O)./2;
    plotProf = (plotProf_U + plotProf_O)./2;
    plotGS = (plotGS_U + plotGS_O)./2;
    plottotalP = (plottotalP_U + plottotalP_O)./2;

    % initialize x-axis
    x = 1:m;

    % figure settings
    figure('units','normalized','outerposition',[0 0 1 1])
    set(0,'DefaultAxesFontSize',12,'DefaultTextFontSize',10,'DefaultLineLineWidth',0.8)
    
    % write labels for graph legends
    for i = 1:n
        if (i <= n_opt)
            labels{i} = strcat('KTR #',num2str(i),' bidding optimally');
        else
            labels{i} = strcat('KTR #',num2str(i),' bidding non-optimally');
        end
    end

    % plot government payment
    subplot(1,2,1)
    for i = 1:n
        plot(x,plotGP(i,:))
        hold on
    end
    xlabel('Runs');
    ylabel('Average Goverment Payment');
    title('Goverment Payment vs Runs');
    legend(labels,'Location','northwest');

    % plot government savings
    subplot(1,2,2)
    for i = 1:n
        plot(x,plotGS(i,:))
        hold on
    end
    xlabel('Runs');
    ylabel('Average Goverment Savings');
    title('Goverment Savings vs Runs');
    legend(labels,'Location','northwest');

    % plot under-run sharing ratio
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(1,2,1)
    for i = 1:n
        plot(x,plotSR_U(i,:))
        hold on
    end
    xlabel('Runs');
    ylabel('Average Sharing Ratio');
    title('Under-run Contractor Sharing Ratio vs Runs');
    axis([0 m 0 1]);
    legend(labels,'Location','northwest');

    % plot over-run sharing ratio
    subplot(1,2,2)
    for i = 1:n
        plot(x,plotSR_O(i,:))
        hold on
    end
    xlabel('Runs');
    ylabel('Average Sharing Ratio');
    title('Over-run Contractor Sharing Ratio vs Runs');
    axis([0 m 0 1]);
    legend(labels,'Location','northwest');

    %{
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(1,2,1)
    for i = 1:n
        plot(x,plotFT(i,:))
        hold on
    end
    xlabel('Runs');
    ylabel('Average Fee');
    title('Average Fee at Target Price vs Runs');
    legend(labels,'Location','northwest');

    subplot(1,2,2)
    for i = 1:n
        plot(x,plotFO(i,:))
        hold on
    end
    xlabel('Runs');
    ylabel('Average Fee');
    title('Average Fee at Optimistic Price vs Runs');
    legend(labels,'Location','northwest');
    %}

    % pie chart of winning percentage
    figure
    avgWins = avgWins./m;
    pie(avgWins);
    title('Percent Won By Each Contractor');
    legend(labels,'Location','eastoutside');

    % plot average contractor profit
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(1,2,1)
    for i = 1:n
        plot(x,plotProf(i,:))
        hold on
    end
    xlabel('Runs');
    ylabel('Contractor Profit Per Contract');
    title('Contractor Profit Average vs Runs');
    legend(labels,'Location','northwest');

    % plot total contractor profit
    subplot(1,2,2)
    for i = 1:n
        plot(x,plottotalP(i,:))
        hold on
    end
    xlabel('Runs');
    ylabel('Total Contractor Profit');
    title('Contractor Profit vs Runs');
    legend(labels,'Location','northwest');
end
 
end
