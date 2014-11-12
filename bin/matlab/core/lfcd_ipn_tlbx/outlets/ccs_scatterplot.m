function [ r, p ] = ccs_scatterplot( x, y, covar, x_model, idx_type1, idx_type2, ...
    fig_title, x_label, y_label, label_type1, label_type2, fig_dir, fig_prefix)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x = reshape(x, numel(x), 1);
y = reshape(y, numel(y), 1);
% Basic Computation
[b, bint, y_res] = regress(y, covar);
if numel(x) > 25
    [r, p] = corr(x, y_res);
else
    [r, p] = corr(x, y_res, 'type', 'Spearman');
end
if ndims(y_res) ==1
    [p1,S1] = polyfit(x,y_res,1);   
    y_fit1 = polyval(p1,x_model);
    % Plots
    figure('Units', 'pixels', 'Position', [100 100 800 400]); 
    hold on; %x(idx_type1), y_res(idx_type1)
    hPlot_type1 = plot(x(idx_type1), y_res(idx_type1), 'o'); 
    hPlot_type2 = plot(x(idx_type2), y_res(idx_type2), 'o');
    hPlot_fit1 = plot(x_model, y_fit1);
    % Adjust Line Properties (Functional)
    set(hPlot_type1, 'LineWidth', 2, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', 'r');
    set(hPlot_type2, 'LineWidth', 2, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', 'b');
    set(hPlot_fit1, 'LineWidth', 3, 'Color', [.3 .3 .3], 'LineStyle', '-.');
    hXLabel = xlabel(x_label); hYLabel = ylabel(y_label); hTitle = title(fig_title);
    hLegend = legend( ...
    [hPlot_type1, hPlot_type2, hPlot_fit1], ...
        label_type1 , ...
        label_type2 , ...
        'Linear Fit Model');
    % Adjust Font and Axes Properties
    set( gca, 'FontName', 'Helvetica' );
    set([hXLabel, hYLabel], 'FontName', 'AvanteGarde');
    set([hXLabel, hYLabel, hLegend, hTitle], 'FontSize', 14);
    set(gca, ...
        'Box'         , 'off'     , ...
        'TickDir'     , 'out'     , ...
        'TickLength'  , [.02 .02] , ...
        'XMinorTick'  , 'on'      , ...
        'YMinorTick'  , 'on'      , ...
        'YGrid'       , 'on'      , ...
        'XColor'      , [.3 .3 .3], ...
        'YColor'      , [.3 .3 .3], ...
        'xLim'        , [min(x_model)-1 max(x_model)+1]    , ...
        'LineWidth'   , 1         );
    % Export to EPS
    if p < 0.1
        set(gcf, 'PaperPositionMode', 'auto');
        print('-depsc2', [fig_dir '/' fig_prefix '_' fig_title '.eps'])
    end
    %close;
end


