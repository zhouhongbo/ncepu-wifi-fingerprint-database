function drawRssBars(X, Y, width, M, S, titleString)
    bottom = -110;
    top = -40;
    figure('PaperUnits','centimeters','PaperSize',[30,20],'PaperPosition',[0 0 30 20]);
    [nRows, nCols] = size(M);
    for i = (1:nRows)
        for j = (1:nCols)
            drawbar(X(i,j), Y(i,j), width/2, M(i,j), S(i,j), bottom);
        end
    end

    zlim = [bottom, top];
    
    axis([min(X(:))-width, max(X(:))+width, min(Y(:))-width, max(Y(:))+width, zlim]);
    caxis(zlim);
    grid on;
    
    title(titleString);
    xlabel('x');
    ylabel('y');
    zlabel('rssi (dBm)');
    
    cbh = colorbar;
    ylabel(cbh, 'dBm');
    colormap(jet);

    function drawbar(x, y, width, m, s, bottom)
        h(1) = patch(width.*[-1 -1  1  1]+x, width.*[-1  1  1 -1]+y, bottom*[ 1  1  1  1], 'b');
        h(2) = patch(width.*[-1 -1  1  1]+x, width.*[-1  1  1 -1]+y, m + s.*[ 1  1  1  1], 'b');
        
        patch([x x], [y y], [bottom m], 'b');
        
        h(3) = patch(width.*[-1 -1  1  1]+x, width.*[-1 -1 -1 -1]+y, m + s.*[-1  1  1 -1], 'b');
        h(4) = patch(width.*[-1 -1 -1 -1]+x, width.*[-1 -1  1  1]+y, m + s.*[-1  1  1 -1], 'b');
        h(5) = patch(width.*[-1 -1  1  1]+x, width.*[ 1  1  1  1]+y, m + s.*[-1  1  1 -1], 'b');
        h(6) = patch(width.*[ 1  1  1  1]+x, width.*[-1 -1  1  1]+y, m + s.*[-1  1  1 -1], 'b');
        
        set(h([1,2]),'facecolor', 'flat', 'FaceVertexCData', m.*[ 1; 1; 1; 1]);
        set(h([3,4,5,6]),'facecolor', 'flat', 'FaceVertexCData', m + s.*[-1; 1; 1;-1], 'FaceColor', 'interp');
    end
end