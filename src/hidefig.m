function h = hidefig(vargin)

if nargin == 0
  h = figure('visible', 'off');
else
  h = figure(vargin, 'visible', 'off');
end
