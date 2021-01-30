function [DIN, DOUT, fnms] = dnnTrainer(IMG, CNTR, nItrs, nFigs, fldPreds, NPF, NPD, NLAYERS, TRNFN, sav, vis, par)
%% dnnTrainer: training algorithm for recursive displacement learning method
% This is a description
%
% Usage:
%   [DIN, DOUT, fnms] = dnnTrainer(IMG, CNTR, nItrs, nFigs, ...
%       fldPreds, NPF, NPD, NLAYERS, TRNFN, sav, vis, par)
%
% Input:
%   IMG: cell array of images to be trained
%   CNTR: cell array of contours to train from images
%   nItrs: total recursive interations to train D-Vectors
%   nFigs: number of figures opened to show progress of training
%   fldPreds: boolean to fold predictions after each iteration
%   NPF: principal components to smooth predictions
%   NPD: principal components for sampling core patches (default 5)
%   NLAYERS: number of layers to use with fitnet (default 5)
%   TRNFN: training function fitnet (default 'trainlm')
%   sav: boolean to save output as .mat file
%   vis: boolean to visualize output
%   par: boolean to run with parallelization or with single-thread
%
% Output:
%   net: cell array of trained network models for each iteration
%   evecs: cell array of eigenvectors for each iteration
%   mns: cell array of means for each iteration
%   fnms: cell array of file names for the figures generated
%
% Author Julian Bustamante <jbustamante@wisc.edu>
%

%% Run the Algorithm!
% Misc setup
allFigs = 1 : nFigs;
fnms    = cell(1, nFigs);
numCrvs = numel(IMG);
sprA    = repmat('=', 1, 80);
sprB    = repmat('-', 1, 80);
eIdxs   = double(sort(Shuffle(numCrvs, 'index', numel(allFigs))));

% Trained Neural Networks and Eigen Vectors for each iteration
[net, evecs, mns] = deal(cell(1, nItrs));

%% Set up figures to check progress
if vis
    for fidx = allFigs
        figclr(fidx);
        
        idx = eIdxs(fidx);
        myimagesc(IMG{idx});
        hold all;
        ttl = sprintf('Target vs Predicted\nContour %d', idx);
        title(ttl);
        drawnow;
        
        fnms{fidx} = sprintf('%s_TargetVsPredicted_%dIterations_Contour%03d', ...
            tdate, nItrs, idx);
    end
else
    fnms = [];
end

%% Run the algorithm!
tAll = tic;
for itr = 1 : nItrs
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Get Tangent Bundle, Displacement Vectors, and Frame Bundles
    tItr = tic;
    fprintf('\n%s\nRunning iteration %d of %d\n%s\n', sprA, itr, nItrs, sprB);
    
    t = tic;
    fprintf('Extracting data from %d Curves', numCrvs);
    
    if itr == 1
        [SCLS , ZVECS , TRGS] = masterFunction2(IMG, CNTR, par);
    else
        [SCLS , ZVECS] = masterFunction2(IMG, CNTR, par, trgpre);
    end
    
    fprintf('...DONE! [%.02f sec]\n', toc(t));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Compute target displacements
    t = tic;
    fprintf('Computing target values for %d segments of %d curves...', ...
        size(TRGS,1), size(TRGS,3));
    
    [DVECS, dsz] = computeTargets(TRGS, ZVECS, 1, par);
    
    fprintf('DONE! [%.02f sec]\n', toc(t));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Run a fitnet to predict displacement vectors from scaled patches
    t = tic;
    fprintf('Using neural net to train %d targets...', size(SCLS,1));
    
    % Parallelization doesn't seem to work sometimes
    dpar = 0; % Don't run this with parallelization [causes too many problems]
    [dpre , net{itr}, evecs{itr}, mns{itr}] = nn_dvectors( ...
        SCLS, DVECS, dsz, dpar, NPD, NLAYERS, TRNFN);
    fprintf('DONE! [%.02f sec]\n', toc(t));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Project displacements onto image frame
    t = tic;
    fprintf('Computing target values for %d segments of %d curves...', ...
        size(dpre,1), size(dpre,3));
    
    trgpre = computeTargets(dpre, ZVECS, 0, par);
    
    if fldPreds
        %% Smooth predicted targets using PCA on predicted displacement vectors
        tt = tic;
        fprintf('Smoothing %d predictions with %d PCs...', ...
            size(trgpre,1), NPF);
        
        % Run PCA on X-Coordinates
        dx  = squeeze((trgpre(:,1,:)))';
        pdx = myPCA(dx, NPF);
        
        % Run PCA on Y-Coordinates
        dy  = squeeze((trgpre(:,2,:)))';
        pdy = myPCA(dy, NPF);
        
        % Back-Project and reshape
        dprex  = reshape(pdx.SimData', [size(trgpre,1) , 1 , numCrvs]);
        dprey  = reshape(pdy.SimData', [size(trgpre,1) , 1 , numCrvs]);
        trgpre = [dprex , dprey , ones(size(dprex))];
        fprintf('DONE! [%.02f sec]...', toc(tt));
        
    end
    
    fprintf('DONE! [%.02f sec]\n', toc(t));
    
    %% Show iterative curves predicted
    t = tic;
    if vis
        for fidx = allFigs
            set(0, 'CurrentFigure', allFigs(fidx));
            fprintf('Showing results from Iteration %d for Contour %d...\n', ...
                itr, eIdxs(fidx));
            % Iteratively show predicted d-vectors and tangent bundles
            idx = eIdxs(fidx);
            myimagesc(IMG{idx});
            hold on;
            
            % Show ground truth contour/displacement vector
            toplot = [TRGS(:,1:2,idx) ; TRGS(1,1:2,idx)];
            plt(toplot, 'g--', 2);
            
            % Show predicted displacement vector
            toplot = [trgpre(:,1:2,idx) ; trgpre(1,1:2,idx)];
            plt(toplot, 'y-', 2);
            
            % Show tangent bundle with tangents and normals pointing in direction
            toplot = [ZVECS(:,:,idx) ; ZVECS(1,:,idx)];
            qmag = 10;
            plt(toplot(:,1:2), 'm-', 2);
            quiver(toplot(:,1), toplot(:,2), toplot(:,3)*qmag, toplot(:,4)*qmag, ...
                'Color', 'r');
            quiver(toplot(:,1), toplot(:,2), toplot(:,5)*qmag, toplot(:,6)*qmag, ...
                'Color', 'b');
            hold off;
            
            ttl = sprintf('Target vs Predicted\nContour %d | Iteration %d', ...
                idx, itr);
            title(ttl);
            
            drawnow;
        end
    end
    % Done with the iteration
    fprintf('DONE! [%.02f sec]\n%s\n', toc(t), sprB);
    fprintf('Ran Iteration %d of %d: %.02f sec\n%s\n', ...
        itr, nItrs, toc(tItr), sprA);
    
end

% Store output
DIN  = struct('IMGS', IMG, 'CNTRS', CNTR);
DOUT = struct('Net', net, 'EigVecs', evecs, 'MeanVals', mns);

fprintf('\n%s\nFull Run of %d Iterations: %.02f sec\n%s\n', ...
    sprA, nItrs, toc(tAll), sprA);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if sav
    %% Data for predicting validation set
    % Need to save the neural networks, and what else?
    TN  = struct('Net', net, 'EigVecs', evecs, 'MeanVals', mns);
    dnm = sprintf('%s_DVecsNN_%dIterations_%dCurves', ...
        tdate, nItrs, numCrvs);
    save(dnm, '-v7.3', 'TN');
    
    %% PCA to fold final iteration of predictions
    dx  = squeeze((trgpre(:,1,:)))';
    xnm = sprintf('FoldDVectorX');
    pcaAnalysis(dx, NPF, sav, xnm);
    
    % Run PCA on Y-Coordinates
    dy  = squeeze((trgpre(:,2,:)))';
    ynm = sprintf('FoldDVectorY');
    pcaAnalysis(dy, NPF, sav, ynm);
end
end


