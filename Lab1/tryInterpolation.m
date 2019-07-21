% 1D interpolation
A=[6 3 1 9 8 3 6 5 1]; % 9 numbers
B=zeros(1,15);
for i=1:15
    B(i)=A(round(i*(9/15)));
end
for j=1:5
    C(j)=A(round(j*(9/5)));
end
n=1:9;
figure
stem(A)
figure 
stem(B)
figure 
stem(C)

% 2D
for i=1:x
    for j=1:y
        output_file(i,j)=I(round(i*(col/x)),round(j*(row/y)));
    end
end
