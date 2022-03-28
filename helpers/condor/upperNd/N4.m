function [Y,Xf,Af] = N4(X,~,~)
%N4 neural network simulation function.
%
% Auto-generated by MATLAB, 11-Feb-2022 15:21:39.
% 
% [Y] = N4(X,~,~) takes these arguments:
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
x1_step1.xoffset = [-1393.82804421394;-1540.5329373182;-1349.79168145112;-1640.55202664048;-1471.63909873669;-1414.57031511166;-1185.47128288875;-1095.06512513266;-839.522533585136;-814.127333995727;-1298.15265612617;-722.618267930695;-694.05086543704;-977.279640257327;-689.056041348459;-863.536078982334;-606.06015823493;-605.241883024479;-804.363474169388;-582.861869528162];
x1_step1.gain = [0.000560431122317984;0.000605109005503322;0.000762224232191701;0.000651624427995533;0.000814818485084016;0.000731852637429512;0.000973891048947734;0.00095198362697109;0.00103611120732898;0.00106737506754642;0.000827691023640352;0.00108572016852455;0.00139880207639084;0.00126133337309345;0.00131173126551333;0.00131523072880442;0.00176000347875798;0.00161984490509096;0.0013072977641767;0.00189508311216863];
x1_step1.ymin = -1;

% Layer 1
b1 = [3.1986592457703197923;4.9873916692500408487;-1.1926751832031510236;0.67004528135130470012;1.5217349360455181273];
IW1_1 = [-1.3296186966645140437 -0.45920901804941910429 1.1828905550264949831 2.2301481080862917139 -0.89222215388278958148 0.33898922062021275003 -0.63654178460925414651 1.3895946800638931951 -1.0587501198198274732 -1.1901593908485819107 0.4337866290527165325 -2.6591603093983899875 -1.1608551594612559477 -0.23663853940714207891 2.4673179974041059559 -1.8023664568225588045 -0.33964333391676299057 2.2062380223462083606 -1.2713733202489776453 -2.3525594390191288952;1.7037962480465747017 -1.9378793605374218245 4.772327562432672643 -3.5492429013141335581 1.3252162411165071543 -0.34259583634505319516 -5.3209351574783063654 3.6230997091623380335 -1.2242005109190889911 -2.1789010363283236593 5.6522788734791573617 1.488420619266198841 1.8082753763303514027 -0.99164336341940317876 -0.29565636289834734685 -2.8554345864616594852 2.845679851971917973 0.28046698679501635976 -6.1383697642811947404 -1.0575342847456654649;3.4187785176092315709 -2.6925181391073875758 0.075031702051383791785 -0.50576363274554125837 3.6277991196456365053 1.1436253744829056878 0.80332652333836596092 -1.1020247126917761538 -0.80943868580199662688 -5.400240839435246798 -1.3372306255858308344 -2.326714813628668832 -0.52623355888762457511 -0.58850192604284434772 -2.3373657072709477234 -1.1947973872838186793 0.64542026304281840954 0.054742191081485029602 -0.51689571887628671387 -0.97336488282928224081;2.2156033552784291096 -3.1784663013182363756 -0.89480741789646356388 -1.4167343058719250593 -0.058733340790382781993 0.67542695414573561408 1.5494223655619943081 0.71000061207998965696 -0.903448510751035605 -3.6619624193772839504 0.50781852445721331613 0.24359596695516988474 0.0034278660662126862746 0.62300618586125833254 -1.7983964471476041602 -0.5139434401708711242 0.19891959196763497886 -0.063298507993806679695 -0.46934732249110150404 -0.30081995389641619232;1.948800909523989322 -0.80286811345186559485 2.6573524200517204541 1.9843446085569145243 2.6812973202714793786 -1.2313467231479142683 -0.077171060672621250021 -2.7535961482807409517 2.3151157419452554898 0.13743850037749266724 1.2411778260191499434 -1.8179391303127714341 -0.82383917608674772648 -0.45271831722088856642 0.065487132557033339575 1.9598671990087634942 0.53093752908465075002 -1.621700156348395927 0.86803792345434316324 0.67907056154323863773];

% Layer 2
b2 = [0.44438528426706092045;-0.085183772233554652664];
LW2_1 = [-0.12811362492760328124 0.022964484092596177539 0.055998046652441214877 -0.058632480869186008599 -0.052129352371414465483;0.065217674417255830366 -0.064014171554822960064 -0.074213933061805723024 0.10618300384459222752 0.080523187251505673467];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.133605829999912;0.13617182683513];
y1_step1.xoffset = [-9.56345350416674;-7.54125839440285];

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
