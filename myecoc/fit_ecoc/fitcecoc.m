function obj = fitcecoc(X,Y,varargin)
%FITCECOC Fit a multiclass model for Support Vector Machine or other classifiers.
%   OBJ=FITCECOC(TBL,Y) fits K*(K-1)/2 binary SVM models using the "one
%   versus one" encoding scheme for data in the table TBL and response Y.
%   TBL contains the predictor variables. Y has K classes (levels) and can
%   be any of the following:
%      1. An array of class labels. Y can be a categorical array, logical
%         vector, numeric vector, or cell array of strings.
%      2. The name of a variable in TBL. This variable is used as the
%         response Y, and the remaining variables in TBL are used as
%         predictors.
%      3. A formula string such as 'y ~ x1 + x2 + x3' specifying that the
%         variable y is to be used as the response, and the other variables
%         in the formula are predictors. Any table variables not listed in
%         the formula are not used.
%   The returned OBJ is an object of class ClassificationECOC.
%
%   OBJ=FITCECOC(X,Y) is an alternative syntax that accepts X as an
%   N-by-P matrix of predictors with one row per observation and one column
%   per predictor. Y is the response and is an array of N class labels. 
%
%   Use of a matrix X rather than a table TBL saves both memory and
%   execution time.
%
%   Use FITCECOC with optional parameters to fit other models using
%   error-correcting output code (ECOC).
%     
%   OBJ=FITCECOC(X,Y,'PARAM1',val1,'PARAM2',val2,...) specifies optional
%   parameter name/value pairs:
%       'CategoricalPredictors' - List of categorical predictors. Pass
%                        'CategoricalPredictors' as one of:
%                          * A numeric vector with indices between 1 and P,
%                            where P is the number of columns of X or
%                            variables in TBL.
%                          * A logical vector of length P, where a true
%                            entry means that the corresponding column of X
%                            or T is a categorical variable. 
%                          * 'all', meaning all predictors are categorical.
%                          * A cell array of strings, where each element
%                            in the array is the name of a predictor
%                            variable. The names must match entries in
%                            'PredictorNames' values.
%                        Default: for a matrix input X, no categorical
%                        predictors; for a table TBL, predictors are
%                        treated as categorical if they are cell arrays of
%                        strings, logical, or categorical.
%       'ClassNames'   - Array of class names. Use the data type that
%                        exists in Y. You can use this argument to order
%                        the classes or select a subset of classes for
%                        training. Default: All class names in Y.
%       'Cost'         - Square matrix, where COST(I,J) is the
%                        cost of classifying a point into class J if its
%                        true class is I. Alternatively, COST can be a
%                        structure S with two fields: S.ClassificationCosts
%                        containing the cost matrix C, and S.ClassNames
%                        containing the class names and defining the
%                        ordering of classes used for the rows and columns
%                        of the cost matrix. For S.ClassNames use the data
%                        type that exists in Y. Default: COST(I,J)=1 if
%                        I~=J, and COST(I,J)=0 if I=J.
%       'CrossVal'     - If 'on', grows a cross-validated ECOC model with
%                        10 folds. You can use 'KFold', 'Holdout',
%                        'Leaveout' and 'CVPartition' parameters to
%                        override this cross-validation setting. You can
%                        only use one of these four options ('KFold',
%                        'Holdout', 'Leaveout' and 'CVPartition') at a
%                        time. As an alternative, you can cross-validate
%                        later using the CROSSVAL method. Default: 'off'
%       'CVPartition'  - A partition created with CVPARTITION to use in
%                        the cross-validation.
%       'Holdout'      - Holdout validation uses the specified fraction
%                        of the data for test, and uses the rest of the
%                        data for training. Specify a numeric scalar
%                        between 0 and 1.
%       'KFold'        - Number of folds to use in cross-validation, a
%                        positive integer. Default: 10
%       'Leaveout'     - Use leave-one-out cross-validation by setting to
%                        'on'. 
%       'Coding'       - Either string or matrix of size K-by-L for K
%                        classes and L binary learners. 
%                          * If you pass 'Coding' as a string, use on of:
%                              'onevsone' or 'allpairs'
%                              'onevsall'
%                              'binarycomplete'
%                              'ternarycomplete'
%                              'ordinal'
%                              'sparserandom'
%                              'denserandom'
%                          * If you pass 'Coding' as a matrix, compose this
%                            matrix using the following rules:
%                              - Every element of this matrix must be one
%                                of: -1, 0, and +1. 
%                              - Every column must contain at least one -1
%                                and at least one +1.
%                              - There are no equal columns or columns
%                                equal after a sign flip. 
%                              - There are no equal rows.
%                        See help for DESIGNECOC for details.
%                        Default: 'onevsone'
%       'FitPosterior' - True or false. If true, classification scores
%                        returned by the binary learners are transformed
%                        to posterior probabilities and the PREDICT method
%                        of the ECOC model OBJ can compute ECOC posterior
%                        probabilities. Default: false
%       'Learners'     - A cell array of binary learner templates or a
%                        single binary learner template. You must construct
%                        every template by calling one of:
%                        templateDiscriminant, templateEnsemble,
%                        templateKNN, templateSVM, and templateTree. If you
%                        pass 'Learners' as a single template object,
%                        FITCECOC will construct all binary learners using
%                        this template. If you pass a cell array of
%                        objects, its length must match the number of
%                        columns in the coding matrix. FITCECOC then uses
%                        the l-th template to construct a binary learner
%                        for the l-th column of the coding matrix. If you
%                        pass one binary learner with default parameters,
%                        you can pass 'Learners' as a string with the name
%                        of the binary learner, for example, 'SVM'.
%                        Default: 'SVM'
%       'Options'      - A struct that contains options specifying whether
%                        to use parallel computation when training binary
%                        learners. This argument can be created by a call
%                        to STATSET. FITCECOC uses the following fields:
%                            'UseParallel'
%                            'UseSubstreams'
%                            'Streams'
%                        For information on these fields see PARALLELSTATS.
%
%                        NOTE: If 'UseParallel' is TRUE and 'UseSubstreams'
%                        is FALSE, then the length of 'Streams' must equal
%                        the number of workers used by FITCECOC. If a
%                        parallel pool is already open, this will be the
%                        size of the parallel pool. If a parallel pool is
%                        not already open, then MATLAB may try to open a
%                        pool for you (depending on your installation and
%                        preferences). To ensure more predictable results,
%                        it is best to use the PARPOOL command and
%                        explicitly create a parallel pool prior to
%                        invoking FITCECOC with 'UseParallel' set to TRUE.
%       'PredictorNames' - A cell array of names for the predictor
%                        variables, in the order in which they appear in X.
%                        Default: {'x1','x2',...}. For a table TBL, these
%                        names must be a subset of the variable names in
%                        TBL, and only the selected variables are used. Not
%                        allowed when Y is a formula. Default: all
%                        variables other than Y.
%       'Prior'        - Prior probabilities for each class. Specify as one
%                        of: 
%                         * A string:
%                           - 'empirical' determines class probabilities
%                             from class frequencies in Y
%                           - 'uniform' sets all class probabilities equal
%                         * A vector (one scalar value for each class)
%                         * A structure S with two fields: S.ClassProbs
%                           containing a vector of class probabilities, and
%                           S.ClassNames containing the class names and
%                           defining the ordering of classes used for the
%                           elements of this vector.
%                        If you pass numeric values, they are normalized
%                        to add up to one. Default: 'empirical'
%       'ResponseName' - Name of the response variable Y, a string. Not
%                        allowed when Y is a name or formula. Default: 'Y' 
%       'Verbose'      - Verbosity level, one of:
%                         0   (Default) FITCECOC does not display any
%                             diagnostic messages.
%                         1   FITCECOC displays a diagnostic message every
%                             time it constructs a new binary learner.
%                         2   FITCECOC displays extra diagnostic messages.
%       'Weights'      - Vector of observation weights, one weight per
%                        observation. FITCECOC normalizes the weights to
%                        add up to the value of the prior probability in
%                        the respective class. Default: ones(size(X,1),1).
%                        For an input table TBL, the 'Weights' value can be
%                        the name of a variable in TBL.
%
%   Example 1: Train a "one versus one" ECOC learner using binary SVM
%            with standardized predictors. Estimate error by
%            cross-validation.
%     t = readtable('fisheriris.csv','format','%f%f%f%f%C');
%     ecoc = fitcecoc(t,'Species','Learners',templateSVM('Standardize',true));
%     cvecoc = crossval(ecoc);
%     kfoldLoss(cvecoc)
%
%   Example 2: Train a "one versus all" ECOC learner using a
%            GentleBoost ensemble of decision trees with surrogate splits.
%            Estimate error by cross-validation.
%     load arrhythmia;
%     tmp = templateEnsemble('GentleBoost',100,templateTree('surrogate','on'));
%     opt = statset('UseParallel',true);
%     ecoc = fitcecoc(X,Y,'Coding','onevsall','Learners',tmp,...
%                     'Prior','uniform','Options',opt);
%     cvecoc = crossval(ecoc,'Options',opt);
%     Yhat = kfoldPredict(cvecoc,'Options',opt);
%     confusionmat(Y,Yhat)
%
% See also designecoc, parallelstats, statset, templateDiscriminant,
% templateEnsemble, templateKNN, templateNaiveBayes, templateSVM,
% templateTree, ClassificationECOC.

%   Copyright 2014-2015 The MathWorks, Inc.

disp('�Լ�д��Fitecoc');
obj = ClassificationECOC.fit(X,Y,varargin{:});
end
