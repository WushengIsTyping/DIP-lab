function output=my_nlm(input,NewMap,t,f)
 [m,n]=size(input);
 pixels = input(:);
 s = m*n;
 psize = 2*f+1;
 nsize = 2*t+1;
 
 padInput = padarray(input,[f f],'symmetric'); 
 NewMap1=padarray(NewMap,[f f],'symmetric'); 
 patches=im2col(NewMap1,[psize psize],'sliding').*im2col(padInput,[psize psize],'sliding');
 
 indexes = reshape(1:s, m, n);
 padIndexes = padarray(indexes, t);
 neighbors = im2col(padIndexes, [nsize, nsize]);
 TT = repmat(1:s, [nsize^2 1]);
 edges = [TT(:) neighbors(:)];
 RR = find(TT(:) >= neighbors(:));
 edges(RR, :) = [];
 
 diff = patches(edges(:,1), :) - patches(edges(:,2), :);
 V = exp(-sum(diff.*diff,2)); 
 W = sparse(edges(:,1), edges(:,2), V, s, s);
 
 if selfsim > 0
    W = W + W' + selfsim*speye(s);
 else
     maxv = max(W,[],2);
     W = W + W' + spdiags(maxv, 0, s, s);
 end
 
  W = spdiags(1./sum(W,2), 0, s, s)*W;
 
 % Compute denoised image
 output = W*pixels;
 output = reshape(output, m , n);
 
 
 