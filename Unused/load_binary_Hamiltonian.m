function H=load_binary_Hamiltonian(filename)

fid=fopen(filename,'rb');
s=fread(fid,1,'double');
nnz=fread(fid,1,'double');
fread(fid,1,'double');
%H=sparse(s,s);
% x=zeros(1,nnz);
% y=zeros(1,nnz);
% r=zeros(1,nnz);
% var_i=1;
display(['nnz: ',num2str(nnz)]);
display(['s: ',num2str(s)]);

f = fread(fid,4*nnz,'double');
f = reshape(f,4,nnz)';
% while var_i<=nnz
%     a = fread(fid,4,'double');
%    x(var_i)=fread(fid,1,'double');
%    y(var_i)=fread(fid,1,'double');
%    r(var_i)=fread(fid,1,'double');
%    im=fread(fid,1,'double');
%    var_i=var_i+1;
%    if (mod(var_i,1e6)==0)
%        display(num2str(var_i));
%    end
% end    
fclose(fid);
% H=sparse(x,y,r,s,s,nnz);
H=sparse(f(:,1),f(:,2),f(:,3),s,s,nnz);
end
