% Written by Nicky Masso
% Updated 4/1/2021
% clear % dont clear every time because the JP2 is huge

% img cropping
%A = imread("LDEM_85S_40M.JP2");
%B = im2uint16(A);
%C = B(13000:13000+7584, 13000:13000+7584);
%imwrite(C,"LDEM_85S_40M_crop.png");
bg = imread("colorimage.png");

% get elevation at an xy
centerx = length(A)/2;
centery = length(A(:,1))/2;


[x,y] = ll2xy(-86, 2, centerx, centery);
[xe,ye] = ll2xy(-89.8, 45, centerx, centery);
[sx,sy] = line(x,y,xe,ye);

for i = 1:length(sx)
    h(i) = 0.5 * double(A(floor(sy(i)), floor(sx(i))));
end

figure(1)
plot((1:length(h))*40/1000, h)
ylim([-4000,6000])
title("Elevation profile for straight path")
xlabel("Horizontal distance (km)")
ylabel("Relative elevation to mean radius (m)")
xlim([0,125])
set(gcf,'position',[10,10,1000,300])

figure(2)
imagesc([0,7584],[0,7584],bg)
hold on
plot(sx,sy,'linewidth',5,'color','white')
xlim([0,7584])
ylim([0,7584])
hold off
title("View of path")
xlabel("Length (km)")
ylabel("Length (km)")
set(gcf,'position',[10,10,600,600])
daspect([1 1 1])

% now lets do a path

[x1,y1] = ll2xy(-86, 2, centerx, centery);
[x2,y2] = ll2xy(-86.5, 8, centerx, centery);
[sx1,sy1] = line(x1,y1,x2,y2);
[x3,y3] = ll2xy(-87.5, 19, centerx, centery);
[sx2,sy2] = line(x2,y2,x3,y3);
[x4,y4] = ll2xy(-88, 16, centerx, centery);
[sx3,sy3] = line(x3,y3,x4,y4);
[x5,y5] = ll2xy(-89.8, 45, centerx, centery);
[sx4,sy4] = line(x4,y4,x5,y5);

sxl = [sx1, sx2, sx3, sx4];
syl = [sy1, sy2, sy3, sy4];

for i = 1:length(sxl)
    hp(i) = 0.5 * double(A(floor(syl(i)), floor(sxl(i))));
end

figure(3)
plot((1:length(hp))*40/1000, hp)
ylim([-4000,6000])
title("Elevation profile for adjusted path")
xlabel("Horizontal distance (km)")
ylabel("Relative elevation to mean radius (m)")
xlim([0,125])
set(gcf,'position',[10,10,1000,300])

figure(4)
imagesc([0,7584*40/1000],[0,7584*40/1000],bg)
hold on
plot(sxl*40/1000,syl*40/1000,'linewidth',5,'color','white')
xlim([0,7584*40/1000])
ylim([0,7584*40/1000])
title("View of path")
xlabel("Length (km)")
ylabel("Length (km)")
set(gcf,'position',[10,10,600,600])
daspect([1 1 1])

%{
height = 1737400 + 0.5 * A(x,y)
%}



function [stepsx, stepsy] = line(x1,y1,x2,y2)
    % subdivide a line
    dx = abs(x2 - x1);
    dy = abs(y2 - y1);

    % we want the larger of the two pixel number of steps
    if dx > dy
        numsteps = dx;
    else
        numsteps = dy;
    end
    
    stepsx = linspace(x1,x2,numsteps);
    stepsy = linspace(y1,y2,numsteps);
end


function [x,y] = ll2xy(lat,lon, cx, cy) 
    % long lat to xy
    r = (lat + 90) * (pi * 2 * 1737400/40) / 360;
    th = lon - 90;
    x = cx + r * cos(deg2rad(th));
    y = cy + r * sin(deg2rad(th));
end
