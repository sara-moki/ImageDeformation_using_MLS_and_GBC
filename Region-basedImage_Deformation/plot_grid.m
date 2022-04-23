function [xx,yy, xfine,yfine,xcoarse,ycoarse, hpatch] = plot_grid(handles)
     resol_row = str2double(get(handles.resolution_r,'string'));
     resol_column = str2double(get(handles.resolution_c,'string'));
     sub_resol_c = str2double(get(handles.sub_resol_c,'string'));
     sub_resol_r = str2double(get(handles.sub_resol_r,'string'));
     resol_c_divid=(resol_column)/sub_resol_c;
     resol_r_divid=(resol_row)/sub_resol_r;
     isaninteger =@(x) mod(x, 1) == 0;   
        if  0 == isaninteger(resol_r_divid) && 0==isaninteger(resol_c_divid) 
            resol_row = resol_row+(sub_resol_r - mod(resol_row,sub_resol_r)) ;
           resol_column = resol_column+(sub_resol_c - mod(resol_column,sub_resol_c)) ;           
        end 
    [xfine,yfine] =  meshgrid(1:1:resol_row+1,1:1:resol_column+1);
    [xcoarse,ycoarse] = meshgrid(1:resol_r_divid:resol_row+1,1:resol_c_divid:resol_column+1);
     hgrid = mesh(xfine,yfine);
     delete(hgrid);
     Z = zeros(resol_row+1,resol_column+1);
     hpatch = surf(xfine,yfine,Z, ... % Plot surface 
               'EdgeColor', 'k','linewidth',1.5);
     xx = xcoarse(:);
     yy = ycoarse(:);