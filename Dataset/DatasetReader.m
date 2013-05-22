function actiondata = DatasetReader(actionid,training)
% DATASETREADER Read dataset action files named according to the format
% aAA_sSS_eEE_skeleton3D.txt
% Takes input the actionId, and returns either the test sequences or the
% segmented ones depending on the 'training' flag

% actionid = 1;
% training = false;

% global path to dataset
global datasetpath

% cell array containing all the actions
actiondata = cell(1);
c = 1;

for s = 1 : 10
    for e = 1 : 3
        % read training/testing files
        if training
            fname = [datasetpath sprintf('a%.2d_s%.2d_e%.2d_skeleton3D_seg.txt',actionid,s,e)];
        else
            fname = [datasetpath sprintf('a%.2d_s%.2d_e%.2d_skeleton3D.txt',actionid,s,e)];
        end
        
        % if file read, format so each pose is in a row, then store in an
        % action cell,
        % normalize depth to 0
        [fid, errm] = fopen(fname);
        if strcmp(errm,'')
            action = cell2mat(textscan(fid,'%f %f %f %*[^\n]'))';
            action = reshape(action, 60, int32(size(action,2)/20))';
            m = repmat(mean(action(:,3:3:size(action,2))')',1,20);
            action(:,3:3:size(action,2)) = action(:,3:3:size(action,2)) - m;
            actiondata{c} = action;
            c = c+1;
            fclose(fid);
        end
    end
end