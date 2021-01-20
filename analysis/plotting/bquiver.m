function bquiver(x,y,u,v,varargin)
%BQUIVER Creates a quiver plot, by interpreting u, v corrdinates as x, y
%would be the origo.

quiver(x,y,u-x,v-y,0,varargin{:});
end