function profit_rate = Ex_Profit_Calc()
% calculates target and optimistic expected profit rates based on industry
% factors (industry risk and profit)

%% --------------------------------------------------------------------- %%
% Table 1 Risk Factors
fprintf('\n');
display('Select the file with Risk Factors.')
pause(1)
fprintf('\n');

% select file
[path, file] = uigetfile({'*.xlsx';'*.*'},'File Selector'); 

% store as matrix
[Risk_factor,txt,raw]=xlsread(path);
Risk_factor=Risk_factor(1:3,1);

% Table 2 Expected Industry Profit
fprintf('\n');
display('Select the file with the Expected Industry Profits.')
pause(1)
fprintf('\n');

% select file
[path, file] = uigetfile({'*.xlsx';'*.*'},'File Selector');

% store as matrix
[Expected_profit,txt,raw]=xlsread(path);

% input risks
Tech_risk=input('What is the Technical and Performance risk of the project? (Low, Medium, or High) ', 's');
Mgmt_risk=input('What is the Management risk of the project? (Low, Medium, or High) ', 's');
CS_risk=input('What is the Cost and Schedule risk of the project? (Low, Medium, or High) ', 's');

n=1;
string1a=strcmp(Tech_risk,'Low');
string1b=strcmp(Tech_risk,'Medium');
string1c=strcmp(Tech_risk,'High');

string2a=strcmp(Mgmt_risk,'Low');
string2b=strcmp(Mgmt_risk,'Medium');
string2c=strcmp(Mgmt_risk,'High');

string3a=strcmp(CS_risk,'Low');
string3b=strcmp(CS_risk,'Medium');
string3c=strcmp(CS_risk,'High');

Risk_ass= zeros(size(Expected_profit));

for n=1:4
    % technical risk
    if string1a>0
        Risk_ass(1,n)=Expected_profit(1,n);
    elseif string1b>0
        Risk_ass(1,n)=Expected_profit(2,n);
    elseif string1c>0
        Risk_ass(1,n)=Expected_profit(3,n);
    end
    
    % management risk
    if string2a>0
        Risk_ass(2,n)=Expected_profit(1,n);
    elseif string2b>0
        Risk_ass(2,n)=Expected_profit(2,n);
    elseif string2c>0
        Risk_ass(2,n)=Expected_profit(3,n);
    end
    
    % cost and schedule risk
    if string3a>0
        Risk_ass(3,n)=Expected_profit(1,n);
    elseif string3b>0
        Risk_ass(3,n)=Expected_profit(2,n);
    elseif string3c>0
        Risk_ass(3,n)=Expected_profit(3,n);
    end   
end

% 1:2 target profit rate    %3:4 optimistic profit rate
profit_rate=Risk_factor'*Risk_ass; 

end
