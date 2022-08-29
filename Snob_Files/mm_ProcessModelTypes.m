%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function [i,Ix,ModelTypes,VarsUsed] = mm_ProcessModelTypes(model_list, i, Ix, ModelTypes, data, VarsUsed)

k = length(ModelTypes) + 1;
cols = model_list{i+1};     
if(any(cols<1) || any(cols>size(data,2)))
    error('Model specification not possible')
end
if(length(cols) < 1)
    error('Must specify at least one data column for each model type')
end
if(length(unique(cols)) ~= length(cols))
    error('Duplicate model entries found')
end

%% Check that model type i was specified correctly
switch lower(model_list{i})        
    %% Univariate normal distribution
    case {'gaussian','normal','norm','gauss'}
                
        %% Basic data
        for j = 1:length(cols)        
            ModelTypes{k}.type = 'Gaussian';
            ModelTypes{k}.Ivar = cols(j);
            ModelTypes{k}.MinMembers = 4;

            %% Error checking
            if(VarsUsed(cols(j)))
                error(['Data column ', int2str(cols(j)), ': multiple models defined']);
            end     
            
            ix = ~isnan(data(:,ModelTypes{k}.Ivar));            
            y = data(ix,ModelTypes{k}.Ivar);            
            if(std(y) == 0)
                error(['Data column ', int2str(cols(j)), ': zero variance']);
            end            
            
            %% Prior hyperparameters
            % Range for uniform distribution
            ModelTypes{k}.mu0 = min(y);
            ModelTypes{k}.mu1 = max(y);
            
            k = k + 1;
        end
        

    %% Otherwise
    otherwise
        error('Model specification unknown.');
        
end

%% update list
VarsUsed(cols) = true;                            
i = i + 2;        

end