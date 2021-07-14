function [dpre , dnet , evecs , mns] = nn_dvectors(inputs, targets, dsz, par, npd, nlayers, trnfn)
%% nn_dvector: CNN to predict contour segments given a Z-Vector slice
%
%
%
% Parallel/GPU Codes ['par' parameter]:
%   | Input |  CPU  |  GPU   |              Note             |
%   |  ---  |  ---  |  ---   |              ---              |
%   |   0   | 'no'  | 'no'   | Single-Thread                 |
%   |   1   | 'yes' | 'no'   | Parellel CPU workers          |
%   |   2   | 'yes' | 'yes'  | GPU with extra workers on CPU |
%   |   3   | 'yes' | 'only' | GPU only, no CPU              |
%   |   4   | 'no'  | 'yes'  | Not sure this will even work? |
%
% Usage:
%   [dpre , dnet , evecs , mns] = nn_dvectors( ...
%       inputs, targets, dsz, par, npd, nlayers, trnfn)
%
% Input:
%   inputs: vectorized image patches from multiple scales and domains
%   targets: displacement vectors to place from tangent bundle
%   dsz: size to reshape predictions after using the neural net model
%   par: run on single-thread (0), parallelization (1), or with GPU (2)
%   npd: number of Principal Components to reduce inputs (sampled core patches)
%   nlayers: number of hidden layers for neural net
%   trnfn: training algorithm to use (default 'trainlm')
%
% Output:
%   dpre: predicted target values
%   dnet: neural net object after training
%   evecs: eigenvectors after folding input to PC scores
%   mns: column means of the input matrix
%

%% Setup the net
if nargin < 5
    npd     = 10;
    nlayers = 5;
    trnfn   = 'trainlm';
end

% Use with parallelization or GPU
% [NOTE 10.24.2019]
% Parallelization only works sometimes, all of the time, but not always
% (aka use at your own risk, or wait until I get Nathan's GPU)
ppll = 'UseParallel';
gpll = 'UseGPU';
switch par
    case 0
        % No parallel, No GPU
        pll = 'no';
        gll = 'no';
    case 1
        % With parallel, No GPU [for my machine]
        pll = 'yes';
        gll = 'no';
    case 2
        % With parallel, With GPU
        % To run in parallel, with workers each assigned to a different unique
        % GPU, with extra workers running on CPU:
        pll = 'yes';
        gll = 'yes';
    case 3
        %
        % Using only workers with unique GPUs might result in higher speed, as
        % CPU workers might not keep up.
        pll = 'yes';
        gll = 'only';
    case 4
        % No parallel, With GPU [don't see why you'd ever use this]
        pll = 'no';
        gll = 'yes';
end

%% Fold Patches to PC scores
pp    = myPCA(inputs, npd);
scrs  = pp.PCAScores;
evecs = pp.EigVecs;
mns   = pp.MeanVals;

%% Run a fitnet to predict displacement vectors from image patches
dnet = fitnet(nlayers, trnfn);
dnet = train(dnet, scrs', targets', ppll, pll, gpll, gll);

% Predict training set data
dpre = dnet(scrs')';
dpre = reshape(dpre, dsz);
dpre = ipermute(dpre, [1 , 3 , 2]);

end

