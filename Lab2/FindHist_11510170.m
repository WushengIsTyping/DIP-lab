% 孙逸飞 11510170
function hist = FindHist_11510170(I)
mySize = size(I);
I = reshape(I,[1,mySize(1)*mySize(2)]); % 将I由矩阵变为行向量，便于统计直方图
hist = zeros(1,256);
for i = I % 统计直方图
    hist(i+1)=hist(i+1)+1;
end
