function consumption = clearing_aug_rate_NickJohnson(rot)
Bu2m = 0.03539606;          %cubic meters per bushel
consumption_data = 1700;    %bushels per hour
rpm_data = 1750;            % rev per min
%opt_rot  =120;              %rev per min, optimal via src

aug_flux = (consumption_data*Bu2m)/(rpm_data*60);   %cubic meters per rev
consumption = aug_flux*rot;     %cubic meters per min
end