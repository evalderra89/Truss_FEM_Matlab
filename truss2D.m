%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: This code calculates the displacements and stress in a truss 2D,
%          using the finite element method.
% Written By: Esteban Valderrama, on 09/07/2015
%             University of Wisconsin at Platteville
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Clear memory
close all
clear all
clc
%%  Define input data
file = 'problem3.txt';
%%  Read Inputfile (nodes, elements and boundary conditions)
disp(' - Reading Inputfile ')
[nodes, Xy, Ndof, dof, fixedDof, Nglob, nelem, elems, A, E, load, nF] = readFiles(file);
%%  Draw truss 2D
disp(' - Drawing truss ')
[min_coord, max_coord] = drawTruss(nodes, Xy, nelem, elems, dof);
drawLoads(Xy, min_coord, max_coord, nF, load);
%%  Assembly global stiffness matrix
disp(' - Assembling Global Stiffness Matrix ')
[K, ke] = globalStiffness(Ndof, nelem, elems, Xy, E, A);
%%
% The output data will be saved in three different files:
% 1- displacements.txt
% 2- forces.txt
% 3- stress.txt
% The output data is also printed on screen for user review.
disp(' - Solving ... ')
disp(' ')
%% Compute forces
disp('      Computing Forces ')
[F] = globalForces(Ndof, nF, Nglob, load, nodes);
disp(' ')
%% Compute displacements
disp('      Computing Displacements ')
[u] = computeDisplacements(Ndof, fixedDof, K, F, nodes);
disp(' ')
for i = 1:nelem
    dof = elems(i,:);              % Select the element
    f(i,:) = ke(:,:,i) * u(dof,1); % Solve for f
    fprintf('%6i %15.4f %15.4f \n', i, f(i,:)); % Print on scree
end
%% Compute stresses
disp('      Computing Stresses ')
[stress] = computeStress(nelem, u, Xy, E, elems);

% Plot data
hold on
xlabel('X Coordinate','fontsize',20); 
ylabel('Y Coordinate','fontsize',20); 
set(gcf,'Color',[1,1,1])
set(gca,'fontsize',15)
grid on
hold off;