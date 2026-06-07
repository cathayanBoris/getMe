function [evect,evals] = getMeEOF(input)

[m,n]=size(input);
if n>m
    input=input.';
end

mcov=cov(input);

% solve for eigenvectors/eigenvalues

[evect,evalu] = eig(mcov);

[evals, index] = sort(diag(evalu/trace(evalu)),'descend');
evect = evect(:,index);
end