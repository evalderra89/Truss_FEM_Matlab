%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: This code computes and saves the forces in the output file 
%          forces.txt.
% Written By: Esteban Valderrama, on 09/14/2015
%             University of Wisconsin at Platteville
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Fglo] = globalForces(Ndof, nF, Nglob, load, nodes)

Fglo = zeros(Ndof,1); % Define output variable

for n = 1:nF
    % Extract the global numeration of the nodes
    dofn=[Nglob(load(n,1),1),Nglob(load(n,1),2)];
    % Perform the summation of all the loads on each node
    for i = 1:2
        Fglo(dofn(i)) = Fglo(dofn(i))+load(n,i+1);
    end
end

% Open output file for forces
fname = strcat('forces.txt');
fid2=fopen(fname,'w+t');
% Write titles of the forces
fprintf(fid2, '   node        Force x        Force y\n'); % Print on file
fprintf('   node        Force x        Force y\n');       % Print on screen

for i = 1:nodes
    Force(i,:)=[Fglo(2*i-1),Fglo(2*i)]; % Save forces 
    % Write outpus
    fprintf(fid2,'%6i %15.4f %15.4f\n', i, Force(i,:)); % Print on file
    fprintf('%6i %15.4f %15.4f\n', i, Force(i,:));      % Print on screen
end

fprintf(fid2,' Total %15.4f %15.4f\n', sum(Force)); % Print on file
fprintf(' Total %15.4f %15.4f\n', sum(Force));      % Print on screen

fclose(fid2); % Close file