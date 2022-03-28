function [Y,Xf,Af] = N20(X,~,~)
%N20 neural network simulation function.
%
% Auto-generated by MATLAB, 11-Feb-2022 15:21:41.
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
x1_step1.xoffset = [-1411.50609665438;-1549.53380751812;-1319.9514707971;-1436.27683172066;-944.370851523536;-1041.97478868088;-918.739274659653;-995.486252780745;-838.175371380665;-739.485134215924;-1343.25129199523;-761.796259406586;-726.523362476916;-711.180500743604;-592.735119640679;-797.90086764283;-474.026583147394;-701.77003041987;-583.043021959592;-559.674030415844];
x1_step1.gain = [0.000561860389255874;0.000604618106654894;0.000732202946936506;0.000656434246597796;0.000877423310116332;0.000824334434463315;0.00109274282636358;0.000983446864869632;0.00108710914391663;0.00120522223207413;0.000883674896858054;0.00123398823038842;0.00138153157700105;0.00121920624290897;0.00158724245142047;0.00149026473369935;0.00181872533022153;0.00134419174514352;0.00167449990721022;0.00182267214719658];
x1_step1.ymin = -1;

% Layer 1
b1 = [-1.5689289358535352115;0.98512468134344555182;-0.20691596725954339298;1.8635509283878137765;1.9828241336614151891];
IW1_1 = [1.2498825279037077962 0.86972816995782564753 -0.25785023396096606874 0.40531416395667801966 1.0902118701552985236 1.7823353420207910247 -0.60330646836958978785 -1.939885204387857387 1.3528541352750853566 1.2994745291747620275 0.60364421344400753799 -1.4511442826758480518 -3.7743395584869157133 0.7260807925692869258 2.1349727168952674639 -0.11642251632927383409 0.6603693756811920279 1.9510194941475529351 2.3176609367340383905 -1.0536877132773876387;0.099144468544148031675 -0.72975951956193640946 1.1236075051243055167 -0.4812085698968435743 -0.0059303441493956752378 0.40880076718934854618 -0.41811458842799897884 -0.83690268161352909804 0.61571163493282021761 0.32421523877857927332 -0.82370693458092869577 0.36592708858186490106 0.25691861080164885012 -0.23855512682757137877 -0.13708917592707353661 -0.097112868406423802359 0.81587295239029633542 0.24226791155163152069 -0.2039728241247681928 -0.26366564041746198832;0.150165633107441715 2.0601828685886132142 -2.5419580398068131188 0.42158996918536673082 0.75346591079533109525 -1.5828588386646909036 0.63058173110070381284 1.0055020062421680116 -0.067956290579336914304 -0.97821289348865470004 1.6410879597043865896 -0.38183476231976026805 -1.1400334652303625305 1.0751248876575485447 0.10016614196303222362 0.50962163260034476497 -2.0313196379504607769 -0.70776130129163061788 0.65994565025639406741 1.7647867344839895942;-0.77259658484635329589 -1.7940851504762553859 1.866947635718231524 -0.53488485919673078861 0.33644459267348481024 -1.9479533567117761628 -0.17269883242478659136 0.75234630851370876137 -0.32318709372941661906 -1.3154336489636309082 -1.5107584484625125043 0.90779652768880780833 2.4571882612295903314 -1.8476105631432033771 -1.9878355300061631983 -0.99102016092182343421 0.82586714190059873353 -1.6361693414017792758 -0.61258985091319562155 -0.67368330117316110872;0.75353657102722082506 -0.74647029615517035417 2.0319303010484204286 -1.1381412927512588595 -0.088073129954089821037 0.83197587706736131352 -1.0974615699308865047 -2.1388350274402538886 1.4761277029003108119 0.82972463219251113564 -0.74648329052890505242 1.1444721221884193163 -0.14713691227794187255 -0.36135677200125881914 -0.40666013132475503644 0.46681362349836991177 1.0848968372320779707 0.93980157787830576055 -0.70131824949692689319 0.40732887933583578066];

% Layer 2
b2 = [0.17607637399347852991;0.1048834797663920626];
LW2_1 = [0.062549869863802620706 -0.10407277476442428066 -0.012017670272336742829 0.063699366929339418242 0.066829612701126278607;0.052157875613331641795 -0.13014880600761538632 -0.039679902096161207004 0.066326268121942533185 0.055859952433082032952];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.188640661112097;0.194710861520835];
y1_step1.xoffset = [-6.19724453023727;-5.5660671325864];

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
