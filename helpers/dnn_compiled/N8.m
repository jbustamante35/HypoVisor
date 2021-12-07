function [Y,Xf,Af] = N8(X,~,~)
%N8 neural network simulation function.
%
% Auto-generated by MATLAB, 15-Nov-2021 15:18:56.
% 
% [Y] = N8(X,~,~) takes these arguments:
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
x1_step1.xoffset = [-1406.10553448976;-1550.77605486881;-1390.06985638154;-1635.39598595168;-1389.84676982047;-1382.44993285753;-959.14741470568;-1078.52942844422;-862.52139792976;-759.206556567804;-1358.67064451546;-800.229434284501;-658.203752801055;-938.310303403441;-622.703596105495;-649.324798419898;-676.26387773503;-765.767839137234;-625.636651852223;-631.311928824748];
x1_step1.gain = [0.000566497956010525;0.000598855746123855;0.000737451818975329;0.000672641720643379;0.00087001668898185;0.000819177077511701;0.00106991192076485;0.000991171252034196;0.00107213847097233;0.00123166978641269;0.000853332971587794;0.00120999224892528;0.00147661036833049;0.00116677462977195;0.00149156198335777;0.00135674432255309;0.00168762430043903;0.00134677155115043;0.00162479934130958;0.00172065391859361];
x1_step1.ymin = -1;

% Layer 1
b1 = [-11.477229053015554072;-5.1772625299215739858;-2.1584568580750902456;2.9805264248709177899;-2.3359556704970700913];
IW1_1 = [0.57798013564801375974 6.721068698092808269 -18.965379304778373637 -0.49611730750145577318 -0.721303058820048415 9.0244238585460632152 4.4916608471196646235 -1.4645262252925690394 -2.3157901370400799657 16.185804424882984875 5.0537036681083309375 -4.964467329048668276 1.7531570595235916876 -6.8032636676211675208 -4.3045592846036537793 0.83244719696064994885 -6.4669034658862383225 5.6137249964568152194 -5.6860226481029245704 -1.5470528597564245921;1.229045889523661117 4.2224889922570092438 -3.2013020460360857022 2.1688060047590513868 10.317754866825364246 -0.068199484718771297143 0.39371666135002297837 0.26577164112212658953 -3.5927979919578625356 2.5323115946952592381 -0.42840666706359803451 4.7394442267899474786 2.8554048772065740991 1.5507260096681334538 1.0208030305593327469 0.60010219363731720499 -0.99436368864112567589 3.2576277351258404735 2.4963474205773898973 4.6345079434067502078;0.61336270919166246962 0.96429634846126122127 -2.0707856953994219218 -1.2360064928376111038 3.7395252469580211319 -2.5448432844045960621 2.4032739671853424746 4.1630016410122649972 -3.4739630591296131179 1.4987900822796726974 0.2014234995015068419 4.0693828213277223327 2.0381731981904462891 -0.89482404580924779225 -1.7473670544863828535 1.5492635879032650159 1.0431944471464111857 3.0392661879182716334 1.3441638072045838381 0.35346010108254094506;3.4026316012527120236 -5.0684140049497292679 1.5125557106797085094 5.0865347261165370085 2.0199457681717176705 5.0426428254844068988 -1.1705149597507928938 -7.0287904389871442845 10.050490588586663776 -8.0376893473334707352 -5.3071986697431974278 -6.53821145757822908 7.1024189894810687562 5.0336554071978412139 1.6058175432096719604 -1.8573068801140832917 -1.3710648226971438035 -4.6262594761264450582 2.40237904735859642 7.9760933291892079922;1.4611862837601647946 -0.47688403436618087561 -1.8012305318240497964 -0.89251061504371342892 0.35601245536457981622 2.0455803818516282711 1.3064484764590624799 0.74754581811983245032 -0.45118101191462939292 1.5091124691161257321 0.41199260754163269382 -0.61695863132456529865 2.7941921943638354797 -3.0693815351511104517 -2.3734658087651219205 1.3819198098694838173 0.50154761646120660235 -0.10340538579658406504 -0.7528468828748864361 -2.3112457573206328654];

% Layer 2
b2 = [-0.084049706681301281086;0.025812557327736448953];
LW2_1 = [-0.062971556044272930519 0.052143601228339116205 -0.056150209134242158593 -0.033611162375270023372 0.070222685335000853413;0.036946216406558082812 -0.024576741154474186085 0.034536879188580726918 0.018102093665572704245 -0.053780336970737786795];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.162359532070388;0.181902518812512];
y1_step1.xoffset = [-5.50031831496859;-5.74141208121797];

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
