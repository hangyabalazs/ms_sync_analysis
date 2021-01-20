function clearbut(varargin)
%CLEARBUT FILE.MAT VAR clears all the workspace's variables
%except for those desired.
%The jolly character (*) is available.
%
%Ex: clearbut Y X* clears all the workspace's variable
%except Y and those starting with "X" (X1,X2,XX,Xn...)
%Read the workspce's variables
WSv = evalin('base','whos;');
Clear_WSv(1:length(WSv)) = 0;
for y = 1:length(WSv)
    %y-th wrkspace variable
    VAR_w = WSv(y).name;
    for x = 1:nargin
        %x-th string
        VAR_s = varargin{x};
        %Compare the y-th variable and the x-th string
        WSvx = evalin('base',['whos(''' VAR_s ''');']);
        for z = 1:length(WSvx)
            if strcmp(VAR_w,WSvx(z).name)
                Clear_WSv(y) = 1;
            end
        end
    end
    %Clear the undesired variables
    if Clear_WSv(y) == 0
        evalin('base',['clear ' VAR_w])
    end
end