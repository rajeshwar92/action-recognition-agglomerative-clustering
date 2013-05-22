function [ filename ] = synth_name( varargin )
%SYNTH_NAME Return name of synth data file

if nargin == 1
    c = varargin{1};
    d = c(1);
    h = c(2);
    m = c(3);
elseif nargin == 3
    d = varargin{1};
    h = varargin{2};
    m = varargin{3};
else
    error('Invalid Arguments');
end

filename = sprintf('Dataset/Synth/synth_d%d_h%d_m%d', d, h, m);