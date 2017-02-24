function [ output_args ] = fig2png(fig_name)
%TTakes a matlab figure and returnes a highresolution png
openfig(fig_name)
print(fig_name, '-dpng', '-r300')

end

