function [Y,Xf,Af] = N20(X,~,~)
%N20 neural network simulation function.
%
% Auto-generated by MATLAB, 15-Nov-2021 15:18:58.
% 
% [Y] = N20(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = 20xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 2xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [-1398.99901515167;-1560.97644540961;-1299.61366593196;-1455.79802075483;-906.452336229324;-1040.57332805245;-923.619755794695;-930.147824140351;-1017.82572078437;-872.413498775355;-929.483881320716;-841.836996862486;-753.089269078683;-699.563825691831;-756.750902461977;-579.174640987464;-611.189101773349;-809.585671532865;-620.09172344702;-603.110710638183];
x1_step1.gain = [0.000567378530551342;0.000610849009265277;0.00074188337461713;0.000644412160286157;0.000880302985065027;0.000827811562371426;0.0010439530128926;0.0010148417829053;0.00103526810885697;0.00125570368192305;0.00088733154935903;0.00125399774205368;0.00134527661296181;0.00122265951923205;0.00144417827673993;0.00143581049038442;0.00184662186632013;0.00134739903147493;0.00165045378225378;0.00169850788268413];
x1_step1.ymin = -1;

% Layer 1
b1 = [4.4571433071541823878;7.3355816457424767307;-1.6162988944118668044;-1.1936944325255365307;-1.9053200199121131941];
IW1_1 = [-2.330577511973097149 5.7744220184412942132 -7.9803380601904532199 -8.7031301902091691147 3.010779525406829471 -0.17030532428254194222 3.0901177262064445372 -1.4557663155080931006 -3.6077200920733667466 2.3514964444546393452 -5.1669629222445312422 5.7510429986214877118 -3.7856302802335637381 0.73771649698526420291 -3.5461120061434572293 -2.2910350232670495529 0.8010258882346134035 3.8452980077674308035 -2.4052419716821269446 -0.89721682693046855839;-4.7479323598893934388 4.0406043396719129035 13.070841914439055742 -10.286772153110835148 6.2921489777471748539 1.4908659645913902025 -3.2489769538584063469 -7.7949515591381786095 -1.8068968655368131682 -4.4923253083704679511 -5.5528770171836976388 0.6091760830635946089 4.6159178767797079956 -1.3219957768727312875 -7.7170412846692517661 11.811344254013524946 -0.93221464219677419027 -5.0066459823162476894 -2.1242513047419397942 10.527638689463223898;-0.92161608039609954623 3.3652606019259168058 0.50335242556292891791 -2.0444766070108273404 1.0808531484156178593 0.14813857777808184246 -1.1627147007475151508 -1.340428525830958062 -1.2393416635479839183 -3.2060957107444929548 0.96523533219584323195 -0.84074584349334158251 2.7123087519478605856 -0.31517703662449353397 0.56205105590198711774 2.8006729366417131288 0.095134927500771931941 -0.043107793493227394843 -1.4172828284892948769 1.4986272401533133891;-0.71824401778950541786 -1.2764338026752510835 2.2123254447701374836 0.6467060155745301131 -0.029516795365293023445 -0.15397870679250547088 -0.1187614189675375298 0.082979548749691323106 1.5257950657703567288 -1.5308175710682541126 -0.86573240252062588773 -1.0743199049881506646 0.16799847767610190385 -0.36077239713300346402 -0.9466024217159023646 0.79987918777031752349 0.47584759995017472667 -1.1495974633580290369 0.539387240399175516 1.3186315981600820191;-2.7397324243990945902 2.2500689449270083742 1.6826898654216346785 -1.0311223160022606748 2.0199779115790206241 -0.26776333579449618227 -0.14403499596623967061 -0.46495702166696256663 0.90104696458770283662 -5.9069026345054806981 -2.5359903299322432702 -1.425767319524672061 1.8476862300288818819 0.11743599541372333472 -2.7921487310648664959 3.3810444704381903414 -0.21011645728503439146 -0.34047731583018148172 -0.24350594488330631893 1.347090664251777925];

% Layer 2
b2 = [-0.066385651821275301621;-0.040965837814432012887];
LW2_1 = [-0.020329356900296288724 -0.0018309694271897236986 -0.0077559558149744665251 -0.015160515155847313629 0.01884381144358455995;0.065636742840479836425 -0.02593417617197230074 0.089532395368684056236 0.11216761584262792406 -0.094629665176022143003];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.200829654093764;0.219964349955802];
y1_step1.xoffset = [-4.57180398337955;-4.24103678730613];

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
  X = {X};
end

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
  Q = size(X{1},2); % samples/series
else
  Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS

    % Input 1
    Xp1 = mapminmax_apply(X{1,ts},x1_step1);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1);
end

% Final Delay States
Xf = cell(1,0);
Af = cell(2,0);

% Format Output Arguments
if ~isCellX
  Y = cell2mat(Y);
end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
  y = bsxfun(@minus,x,settings.xoffset);
  y = bsxfun(@times,y,settings.gain);
  y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
  x = bsxfun(@minus,y,settings.ymin);
  x = bsxfun(@rdivide,x,settings.gain);
  x = bsxfun(@plus,x,settings.xoffset);
end
