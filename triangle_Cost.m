function randT = triangle_Cost(min,max,mode,n)
% returns n random values according to a triangular distribution with
% lower limit min, upper limit max, and mode mode

% random uniform variable in [0,1]
if (nargin > 3)
    p=rand(n,1); 
else
    p = rand;
end

cutoff = (mode-min)/(max-min);

% algorithm for generating triangular-distributed random variable
if(p<cutoff)
    randT = min + sqrt((mode-min)*(max-min).*p);
else
    randT = max - sqrt((max-mode)*(max-min).*(1-p));
end
