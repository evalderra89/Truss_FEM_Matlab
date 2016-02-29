%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: This function reads the input file.
% Written By: Esteban Valderrama, on 09/14/2015
%             University of Wisconsin at Platteville
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Inputs
% file -> input file.
%%  Outputs
% nodes          -> Number of nodes in the system.
% Xy             -> Nodes coordinates.
% Ndof           -> Number of constraints.
% dof            -> Constraints nodes information.
% Nglob          -> Nodes global enumeration.
% nelem          -> Number of elemets (bars).
% elem           -> Matrix of [nelem x 2] with the elements nodes.
% A              -> Area vector of [nelem x 1].
% E              -> Elasticity modulus vector of [nelem x 1].
% load           -> Force vector of [nodes x 2].
% nF             -> Number of loads.

% Local Variables
% data           -> Reads the information read from the inputfile.
% mline          -> Reads the keywords in the inputfile.
% i              -> For loop iteration control.
% cont           -> Counter.
%%  Input file definition
% You have to create an input file in a .txt file, see the following
% example:
%
% $Nodes                    -> Keyword always present
% 14                        -> Number of nodes of the system
% $location_x_y_dof_x_y     -> Keyword always present
% 0 0 1 1                   -> Node coord. in X, node coord. in Y, BC in X, BC in Y
% 0.125 0 0 0
% 0.1875 0 0 0
% 0.25 0 0 0
% 0.3125 0 0 0
% 0.375 0 0 0
% 0.5 0 0 1
% 0.5 0.25 0 0
% 0.4375 0.25 0 0
% 0.375 0.25 0 0
% 0.25 0.25 0 0
% 0.125 0.25 0 0
% 0.0625 0.25 0 0
% 0 0.25 0 0
% $Connexion                -> Keyword always present
% 25                        -> Number of elements in the system
% $Ni_Nj_A_E                -> Keyword always present
% 1 2 1.256e-5 2.49e9       -> 1st node, 2nd node, Area, Elasticity modulus
% 2 3 1.256e-5 2.49e9
% 3 4 1.256e-5 2.49e9
% 4 5 1.256e-5 2.49e9
% 5 6 1.256e-5 2.49e9
% 6 7 1.256e-5 2.49e9
% 7 8 1.256e-5 2.49e9
% 8 9 1.256e-5 2.49e9
% 9 10 1.256e-5 2.49e9
% 10 11 1.256e-5 2.49e9
% 11 12 1.256e-5 2.49e9
% 12 13 1.256e-5 2.49e9
% 13 14 1.256e-5 2.49e9
% 14 1 1.256e-5 2.49e9
% 1 13 1.256e-5 2.49e9
% 13 2 1.256e-5 2.49e9
% 2 12 1.256e-5 2.49e9
% 12 3 1.256e-5 2.49e9
% 3 11 1.256e-5 2.49e9
% 11 4  1.256e-5 2.49e9
% 11 5  1.256e-5 2.49e9
% 5 10 1.256e-5 2.49e9
% 10 6 1.256e-5 2.49e9
% 6 9 1.256e-5 2.49e9
% 9 7 1.256e-5 2.49e9
% $Forces                   -> Keyword always present
% 1                         -> Number of forces BC in the system
% $Nodes_Fh_Fv              -> Keyword always present
% 4 0 -98.1                 -> node, X value, Y value
%%
function [nodes, Xy, Ndof, dof, fixedDof, Nglob, nelem, elem, A, E, load, nF] = readFiles(file)

fid = fopen(file);
[fid, message] = fopen(file,'r');
if(fid < 0)
    fprintf('Filename: %s. \n %s\n',file,message)
    error('Error opening file: ')
    return
end

% Read nodes information
mline = fgetl(fid);
if strcmp(mline, '$Nodes')
    nodes = fscanf(fid,'%d\n',1);  % Save number of nodes
    Ndof = nodes * 2;              % Save number of degres of freedom
    mline = fgetl(fid);
    cont = 0;
    for i = 1:nodes
        data(i,:) = fscanf(fid,'%f %f %f %f\n',4);  % Read entire line
        Xy(i,1) = data(i,1);  % Save node coordinate X
        Xy(i,2) = data(i,2);  % Save node coordinate Y
        % Save constraints
        %     0 -> dof free
        %     1 -> dof fixed
        dof(i,1) = data(i,3);
        dof(i,2) = data(i,4);
        % Generate global nodes
        cont = cont + 1;
        Nglob(i,1) = cont;  % Save global node coordinate X
        cont = cont + 1;
        Nglob(i,2) = cont;  % Save global node coordinate Y
    end
end

pos = 1;
%fixedDof = zeros(Ndof,1)
for i = 1:nodes
    if dof(i,1) == 1
        fixedDof(pos) = Nglob(i,1);
        pos = pos + 1;
    end
    if dof(i,2) == 1
        fixedDof(pos) = Nglob(i,2);
        pos = pos + 1;
    end
end

clear i data

% Read elements information
mline = fgetl(fid);
if strcmp(mline, '$Connexion')
    nelem = fscanf(fid,'%d\n',1);  % Save number of nodes
    mline = fgetl(fid);
    for i = 1:nelem
        data(i,:) = fscanf(fid,'%i %i %f %f\n',4); % Read entire lines
        elem(i,1) = data(i,1);    % Save element node 1
        elem(i,2) = data(i,2);    % save element node 2
        A(i,1) = data(i,3);       % save area of elements
        E(i,1) = data(i,4);       % Save elasticity modulus of elements
    end
end
clear i data

% Read forces information
mline = fgetl(fid);
if strcmp(mline, '$Forces')
    nF = fscanf(fid,'%d\n',1);   % Save number of applied forces
    mline = fgetl(fid);
    for i = 1:nF
        data(i,:) = fscanf(fid,'%i %f %f\n',3); % Read entire lines
        load(i,1) = data(i,1);  % Save # of node with loading
        load(i,2) = data(i,2);  % Save X value
        load(i,3) = data(i,3);  % Save Y value
    end
end
clear i data

fclose(fid);  % Close file
clear fname fid i mline message data  % Erase local variables