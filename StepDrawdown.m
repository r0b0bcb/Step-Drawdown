% For Step-Drawdown Tests given Q and s for 3-step-drawdown tests
%       Clay Barlow, Geoscience Undergraduate
%       @ Utah State University
%
%
%   Inputs: Q in gpm per step, s in ft per step, t in hours per step
%   Outputs: T in gal/day/ft
%   Uses Rorabaugh (1953) method, derived in class
%

function SD = StepDrawdown ()

% creates prompt to input values (default values from GW hw assignment 3)
prompt = {'Enter Q1: ', 'Enter s1: ', 'Enter Q2: ', 'Enter s2: ', 'Enter Q3: ', 'Enter s3: ', 'Enter t per steps: '};
dlgtitle = 'Inputs';
dims = [1 35];
%Wellname = 'Well 5-2';
%definput = {'148.8', '5.29', '218.4', '8.28', '253.2', '9.92', '2.0'};
Wellname = 'Well 5-4';
definput = {'85.2', '0.95', '140.8', '2.13', '299.3', '8.26', '2'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

% Takes inputs and converts from string to numbers, assigns to variable
Q1 = str2double(answer(1));
s1 = str2double(answer(2));
Q2 = str2double(answer(3));
s2 = str2double(answer(4));
Q3 = str2double(answer(5));
s3 = str2double(answer(6));
t = str2double(answer(7));

% Converts Q and s values to Delta Q and Delta s values
dQ1 = Q1;
dQ2 = Q2 - Q1;
dQ3 = Q3 - Q2;

ds1 = s1;
ds2 = s2 - s1;
ds3 = s3 - s2;

% Calculates C values
C12 = ((ds2 / dQ2) - (ds1 / dQ1)) / (dQ1 + dQ2);
C23 = ((ds3 / dQ3) - (ds2 / dQ2)) / (dQ2 + dQ3);
Cav = mean([C12, C23]);

% Calculates B values
B1 = (ds1 / dQ1) - C12 * (dQ1);
B2 = (ds2 / dQ2) - Cav * (2 * dQ1 + dQ2);
B3 = (ds3 / dQ3) - C23 * (2 * dQ1 + 2 * dQ2 + dQ3);

% Calculates Aquifer Loss
AL1 = B1 * dQ1;
AL2 = AL1 + B2 * dQ2;
AL3 = AL2 + B3 * dQ3;

% Calculates Well Loss
WL1 = C12 * Q1^2;
WL2 = WL1 + Cav * (Q2^2 - Q1^2);
WL3 = WL2 + C23 * (Q3^2 - Q2^2);

% Calculates Well Efficiency
WE1 = (B1 * dQ1) / s1;
WE2 = ((B1 * dQ1) + (B2 * dQ2)) / s2;
WE3 = ((B1 * dQ1) + (B2 * dQ2) + (B3 * dQ3)) / s3;

% Calculates Specific Capacity
sc1 = Q1 / s1;
sc2 = Q2 / s2;
sc3 = Q3 / s3;

% Checks that  Aquifer loss + Well loss = s values
Netloss1 = AL1 + WL1;
if s1 == round(Netloss1, 4)
    fprintf('Step 1 test: passed check \n')
else fprintf('Step 1 error \n'); end
    
Netloss2 = AL2 + WL2;
if s2 == round(Netloss2, 4)
    fprintf('Step 2 test: passed check \n')
else fprintf('Step 2 error \n'); end
    
Netloss3 = AL3 + WL3;
if s3 == round(Netloss3, 4)
    fprintf('Step 3 test: passed check \n')
else fprintf('Step 3 error \n'); end

% Creates table with relevant data for 3 steps
format shortG
exportData = array2table([1, Q1, s1, C12, B1, AL1, WL1, WE1, sc1, Netloss1;
                          2, Q2, s2, Cav, B2, AL2, WL2, WE2, sc2, Netloss2;
                          3, Q3, s3, C23, B3, AL3, WL3, WE3, sc3, Netloss3]);
exportData.Properties.VariableNames = {'Step Number','Discharge (Q)','Drawdown (s)','C','B','Aquifer Loss','Well Loss','Well Efficiency','Specific Capacity','Checksum'};

% Save data to excel file?
prompt = {'Save to excel file? Y/N'};
dlgtitle = 'Save to excel?';
dims = [1 35];
definput = {'N'};
save = inputdlg(prompt,dlgtitle,dims,definput);
x = char(save(1));
if x == 'Y'
    % Change # after 'Range' for appending to table
    writetable(exportData,'Barlow_Assign3_Ans.xlsx', 'Sheet', 1, 'Range', 'A6');
else; end

