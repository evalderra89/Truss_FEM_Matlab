%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose: This function draws the loads in the truss.
% Written By: Esteban Valderrama, on 09/14/2015
%             University of Wisconsin at Platteville
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawLoads(Xy, min_coord, max_coord, nF, load)

% Set the size for the force vector
lc = max(max_coord - min_coord)/20;

% Draw loads
for i = 1:nF
   % Horizontal loads
   if load(i,2) ~= 0
      xn = [Xy(load(i,1),1);Xy(load(i,1),1)-lc]; % Get x-location
      yn = [Xy(load(i,1),2);Xy(load(i,1),2)];    % Get y-location
      plot(xn,yn,'r','LineWidth',3)
   end
   % Vertical loads
   if load(i,3) ~= 0
      xn=[Xy(load(i,1),1);Xy(load(i,1),1)];      % Get x-location
      yn=[Xy(load(i,1),2);Xy(load(i,1),2)-lc];   % Get y-location
      plot(xn,yn,'r','LineWidth',3)
   end
end
clear lc i xn yn; % Clear variables