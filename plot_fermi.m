function [ ] = plot_fermi( )
%PLOT_FERMI Summary of this function goes here
%   Detailed explanation goes here

load MEL_E_0_0_0_0.dat
load MEL_Efl_0_0_0.dat
load MEL_Efr_0_0_0.dat
load MEL_TE_0_0_0_0.dat

figure
hold all
plot(abs(MEL_TE_0_0_0_0),MEL_E_0_0_0_0);
max_t = max(abs(MEL_TE_0_0_0_0));
plot(max_t*(fermi(MEL_E_0_0_0_0,MEL_Efl_0_0_0,0.026)-fermi(MEL_E_0_0_0_0,MEL_Efr_0_0_0,0.026)),MEL_E_0_0_0_0);
hold off
end

