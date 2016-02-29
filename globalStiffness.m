%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: This code computes the element and global stiffness matrix.
% Written By: Esteban Valderrama, on 09/14/2015
%             University of Wisconsin at Platteville
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Kglo, ke] = globalStiffness(Ndof, nelem, elems, Xy, E, A)

Kglo=zeros(Ndof); % Define global stiffness matrix

for e = 1:nelem
    ind = elems(e,:); % Elemetn index
    edof = [ind(1)*2-1 ind(1)*2 ind(2)*2-1 ind(2)*2]; % Extract DOF form the global elements
    xa = Xy(ind(2),1) - Xy(ind(1),1); % Element point a
    ya = Xy(ind(2),2) - Xy(ind(1),2); % Element point b
    elength = sqrt(xa^2 + ya^2);      % Element length
    C = xa / elength;                 % Cosine function
    S = ya / elength;                 % Sine function
    T = [C S;-S C];                   % Transformation matrix
    ke(:,:,e) = ((E(e)*A(e)) / elength) * [1 -1;-1 1] * T; % Element Stiffness matrix
    ke_iter = ((E(e)*A(e)) / elength) * [C*C C*S -C*C -C*S;...
                                    C*S S*S -C*S -S*S;...
                                    -C*C -C*S C*C C*S;...
                                    -C*S -S*S C*S S*S];    % Element stiffness matrix
    Kglo(edof,edof) = Kglo(edof,edof) + ke_iter;  % Global stiffness matrix
end
clear fid ind e edof xa ya elength C S T ke_iter % Clear variables