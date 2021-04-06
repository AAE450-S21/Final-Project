function speed = rover_speed_NickJohnson(v,rot)
L = 3;  r = 0.254/2;
aug_rate = clearing_aug_rate_NickJohnson(rot);
aug_vol = pi*r^2*L;
augShaft_clear_t = (aug_vol./aug_rate).*60;
fwd_speed_aug = 2.*r./augShaft_clear_t;

speed = min(fwd_speed_aug,v);
end