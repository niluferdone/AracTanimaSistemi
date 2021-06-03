for i=1:144
    for j=1:144
        
        if C(i,j)=="arka_plan"
            A(i,j,:)=0;
        else
            A(i,j,:)=255;
        end
    end
end

b=rgb2gray(A);
e=graythresh(A);
c=im2bw(A,e);
f = c;
t = strel('square',41);
f = imopen(f,t);
%figure, imshow(f)
bas=1;
kareBas=[];
for i=1:144
    for j=1:144
        if ((f(i,j)==1)&&(bas==1)) 
            kareBas=[i,j];
            bas=0;
        end
    end
end

bas=1;
kareSon=[];
for i=144:-1:1
    for j=144:-1:1
        if ((f(i,j)==1)&&(bas==1)) 
            kareSon=[i,j];
            bas=0;
        end
    end
end

x=[kareBas; kareSon];

  i=1;
for j=1:2:size(x,1)-1
    K=resim(x(j,2):x(j+1,2),x(j,1):x(j+1,1),:);
    K=imresize(K,[40 40]);

    i=i+1;

end