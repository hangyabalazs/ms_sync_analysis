function isNoisy = significant_parts(f,threshMultip)
%SIGNIFICANT_PARTS Returns significantly high amplitude parts of a signal.
%   ISNOISY = SIGNIFICANT_PARTS(F,THRESHMULTIP) computes a signal adapted
%   threshold (median(signal) + c*median absolute deviation(signal)) for
%   recognizing significantly high amplitude parts. Can be used for large 
%   amplitde noise removal.
%   Parameters:
%   F: vecotr, input signal.
%   THRESHMULTIP: number, constant multiplier of MAD.
%   ISNOISY: logical vector, specifying significant parts (=1, 0 otherwise)
%   of the signal.
%
%   See also MAIN_ANALYSIS, THETA_DETECTION, HIPPO_FIELD_MS_UNIT.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

thresh = median(f) + mad(f) * threshMultip;
isNoisy = f >= thresh;
end