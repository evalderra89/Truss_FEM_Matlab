%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: This function calculates the displacements on the degrees of
% freedom and the constraints. The results will be saved in the .txt files,
% Written By: Esteban Valderrama, on 09/14/2015
%             University of Wisconsin at Platteville
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [u] = computeDisplacements(Ndof, fixedDof, K, F, nodes)

free = setdiff([1:Ndof]', [fixedDof]); % Get the degrees of freedom
u_temp = K(free,free) \ F(free,1);     % Compute the value of the displacements using the boundary conditions
u = zeros(Ndof,1);   % Initialize output variable
u(free) = u_temp;    % Save the boundary condition value in the output variable

% Open output file for displacements
fname = strcat('displacements.txt');
fid1=fopen(fname,'w+t');
% Write titles of the displacements
fprintf(fid1, '   node       Displacement x    Displacement y\n'); % Print on file
fprintf('   node       Displacement x    Displacement y\n');       % Print on screen
for i = 1:nodes
    ux = u(i);   % Save x-displacement
    uy = u(i+1); % Save y-displacement
    fprintf(fid1,'%6i %17.4f %17.4f\n', i, ux, uy); % Print on file
    fprintf('%6i %17.4f %17.4f\n', i, ux, uy);      % Print on screen
end
fclose(fid1);           % Close files
clear fname fid1 fid2 i % Erase variables