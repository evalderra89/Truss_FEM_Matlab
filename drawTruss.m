%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: This code draws the truss 2D (nodes, elements, restrictions and
% forces)
% Written By: Esteban Valderrama, on 09/14/2015
%             University of Wisconsin at Platteville
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Inputs
% nodes          -> Number of nodes in the system.
% Xy             -> Nodes coordinates.
% nelem          -> Number of elemets (bars).
% elem           -> Matrix of [nelem x 2] with the elements nodes.
% dof            -> Constraints nodes information.
%%  Outputs
% min_coord      -> Saves the minimum values of the global coordinates.
% max_coord      -> Saves the maximum values of the coordinates.

% Local Variables
% lxy            -> Structure length.
% minaxy         -> Minumum value for drawing the truss.
% maxaxy         -> Maximum value for drawing the truss.
% xe             -> Coordinate X of the nodes on each element.
% ye             -> Coordinate Y of the nodes on each element.
% i              -> For loop iteration control.

function [min_coord, max_coord] = drawTruss(nodes, Xy, nelem, elem, dof)

% Close any figure
clf

%% Determine limiting values for the figure
min_coord = min(Xy);              % Minimum value of coordinates
max_coord = max(Xy);              % Maximum value of coordinates
lxy = max(max_coord - min_coord); % Maximum length
minaxy = (10*min_coord - lxy)/10;
maxaxy = minaxy+6*lxy/5;

% Draw the truss
for i=1:nelem;
   xe=[Xy(elem(i,1),1);Xy(elem(i,2),1)]; % x-coordinate of the element
   ye=[Xy(elem(i,1),2);Xy(elem(i,2),2)]; % y-coordinate of the element
   plot(xe,ye,'k','LineWidth',1);
   if i==1 % Continue the plot in the same figure
      hold on
   end
end
title('Truss 2D') % Plot title
axis([minaxy(1),maxaxy(1),minaxy(2),maxaxy(2)]) % Axis values

% Draw the nodes
for i = 1:nodes
   if dof(i)==1 & dof(i,2)==1 % if the truss is fixed, plot a blue square
     plot(Xy(i,1),Xy(i,2),'bs','LineWidth',2,'MarkerSize',5);
   elseif dof(i,1)==1 % if the truss is fixed in x-axis, plot a green triangle
      plot(Xy(i,1),Xy(i,2),'g<','LineWidth',2,'MarkerSize',5);
   elseif dof(i,2)==1 % if the truss is fixed in y-axis, plot a yellow triangle
      plot(Xy(i,1),Xy(i,2),'y^','LineWidth',2,'MarkerSize',5);
   else % If the truss is free, plot a black circle
      plot(Xy(i,1),Xy(i,2),'ko','LineWidth',2,'MarkerSize',5);
   end
end
hold on;
clear lxy minaxy maxaxy i xe ye; % Clear variables