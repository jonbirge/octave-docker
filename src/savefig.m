function savefig(filename)
% Save current figure to disk as PNG file.

  fig = gcf;
  saveas(fig, [filename '.png']);

end
