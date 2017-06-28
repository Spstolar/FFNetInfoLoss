function[x] = singcheck(B)
%SINGCHECK Returns a multi-method check for singularity.
%   Take a matrix B. First do a quick check to see if any of its 
%   eigenvalues are zero. Then if it passes that, do a more rigorous check
%   on the condition number. Return 1 if not singular, and 0 else.

x = 0;
done = 0;

if sum(eig(B) == 0) > 0
    x = 1;
    done = 1;
end

if done == 0;
    ConditionB = cond(B);
    if ( ConditionB == 0) || (isinf(ConditionB) ==1) || (isnan(ConditionB) == 1) || (ConditionB < .000001) || (ConditionB > 1000000000)
        x = 1;
    end
end