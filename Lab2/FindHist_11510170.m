% ���ݷ� 11510170
function hist = FindHist_11510170(I)
mySize = size(I);
I = reshape(I,[1,mySize(1)*mySize(2)]); % ��I�ɾ����Ϊ������������ͳ��ֱ��ͼ
hist = zeros(1,256);
for i = I % ͳ��ֱ��ͼ
    hist(i+1)=hist(i+1)+1;
end
