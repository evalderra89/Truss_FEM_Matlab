%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: This function calculates the stresses on the degrees of
% freedom and the constraints. The results will be saved in the .txt files,
% Written By: Esteban Valderrama, on 09/14/2015
%             University of Wisconsin at Platteville
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [stress] = computeStress(nelem, u, Xy, E, elems)

% Open output file for stresses
fname = strcat('stress.txt');
fid=fopen(fname,'w+t');

% Write titles of the displacements
fprintf(fid, '  Element     Stress\n');
fprintf('  Element     Stress\n');

stress = zeros(nelem,1);  % Initialize output variable
for e = 1:nelem
    % Compute the nodal coordinates, length, initial and final locations of
    % the nodes on each bar.
    ind = elems(e,:); % Element index
    edof = [ind(1)*2-1 ind(1)*2 ind(2)*2-1 ind(2)*2]; % Degrees of freedom
    xa = Xy(ind(2),1) - Xy(ind(1),1); % Compute distance between points
    ya = Xy(ind(2),2) - Xy(ind(1),2); % Compute distance between points
    elength = sqrt(xa^2 + ya^2);   % Length of the bar
    C = xa / elength;              % Cosine function
    S = ya / elength;              % Sin function
    stress(e,1) = (E(e,1)/elength) * [-C -S C S] * u(edof,1); % Compute stress
    fprintf(fid,'%6i %15.4e\n', e, stress(e,1)); % Print on file
    fprintf('%6i %15.4e\n', e, stress(e,1));     % Print on screen
end
fclose(fid); % Close file
clear fname fid ind edof xa ya elength C S % Erase variables