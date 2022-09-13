
ad data.txt
M(:,1) = data(:,1);
M(:,2) = data(:,2);
M(:,3) = data(:,3);

tic;
plot3(M(:,1),M(:,2),M(:,3));
xmin = min(data(:,1));
ymin = min(data(:,2));
zmin = min(data(:,3));
xmax = max(data(:,1));
ymax = max(data(:,2));
zmax = max(data(:,3));
xc = 0.5*(xmax+xmin);
yc = 0.5*(ymax+ymin);
zc = 0.5*(zmax+zmin);
a = 0.5*abs(xmax-xmin);
b = 0.5*abs(ymax-ymin);
c = 0.5*abs(zmax-zmin);
%得到初始的解
x = M(:,1);
y = M(:,2);
z = M(:,3);


%开始计算误差
L = length(x(:,1));
err = 0;
for i=1:L
    err = err + abs((x(i)-xc)^2/a^2 + (y(i)-yc)^2/b^2+(z(i)-zc)^2/c^2 - 1 );
end
fprintf('xc = %f yc = %f zc = %f, a = %f b = %f c= %f,初始化InitErr = %f\n',xc,yc,zc,a,b,c,err);

%为了测试算法有效性，我们选取0,0,0,1,1,1作为初始值求解
%xc = 0;
%yc = 0;
%zc = 0;
%a = 1;
%b = 1;
%c = 1;
%如果是采用上面的特殊参数验证算法的话，最好将下面的循环改为10000次以得到的更好的结果。
%采样数据量不宜过大，我的磁力计测试数据90k左右的txt，也基本足够了。因为初始解是计算
%出来的，所以能够降低计算量。
x = M(:,1);
y = M(:,2);
z = M(:,3);
%xclast = xc;
yclast = yc;
zclast = zc;
alast = a;
blast = b;
clast = c;
errlast = 100000000000;

for i = 1:1000
    %产生随机扰动
    r = rand(1,6);
    xcnew = xclast + r(1)-0.5;
    ycnew = yclast + r(2)-0.5;
    zcnew = zclast + r(3)-0.5;
    anew = abs(alast + r(4)-0.5);
    bnew = abs(blast + r(5)-0.5);
    cnew = abs(clast + r(6)-0.5);
    errnew = 0;
    for j=1:L
        errnew = errnew + abs((x(j)-xcnew)^2/anew^2 + (y(j)-ycnew)^2/bnew^2+(z(j)-zcnew)^2/cnew^2 - 1 );
    end

    if(errnew<errlast)   % 有更好的解，接受新解
        xclast = xcnew;
        yclast = ycnew;
        zclast = zcnew;
        alast = anew;
        blast = bnew;
        clast = cnew;
        errlast = errnew;
    end
end
fprintf('xc = %f yc = %f zc = %f, a = %f b = %f c= %f,最后InitErr = %f\n',xclast,yclast,zclast,alast,blast,clast,errlast);


avr = (alast+blast+clast)/3;

fprintf('mx = (mx - %f)*%f\n',xclast,alast/avr);
fprintf('my = (my - %f)*%f\n',yclast,blast/avr);
fprintf('mz = (mz - %f)*%f\n',zclast,clast/avr);


toc

