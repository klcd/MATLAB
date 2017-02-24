function [X,Y,C,clr] = draw_procar(kI,B,T,id)

    %% assign colors
    Norb = 3;
    Ni = length(id);
    rgb = [1 1 1 0 0 0 0; ...
           0 1 0 1 1 0 0; ...
           0 0 1 0 1 1 0]';
    Nrgb = size(rgb,1);
    clr = zeros(Ni*Norb,3);

    cnt=1;
    for c = linspace(1,Nrgb,Ni*Norb)
        if floor(c)==c
            clr(cnt,:) = rgb(c,:);
        else
            cc = floor(c);
            clr(cnt,:) = (1-mod(c,1))*rgb(cc,:) + mod(c,1)*rgb(cc+1,:);
        end

        cnt=cnt+1;
    end

    
    %% draw data to buffers    
    Nk = length(kI);
    Nb = size(B(1).E,2);
    Na = size(B(1).s,1);
    
    X = zeros(1,Nk*Nb);
    Y = zeros(1,Nk*Nb);
    C = zeros(Nk*Nb,3);
    
    kpts=linspace(0,1,length(kI));
    cnt=1; ck=1;
    
    for k = kI
        for b=1:Nb
            for a=1:Na
                C(cnt,:) = C(cnt,:) + clr(T(a)*Norb+1,:) * B(k).s(a,b);
                C(cnt,:) = C(cnt,:) + clr(T(a)*Norb+2,:) * B(k).p(a,b);
                C(cnt,:) = C(cnt,:) + clr(T(a)*Norb+3,:) * B(k).d(a,b);
            end
            
            X(cnt) = kpts(ck);
            Y(cnt) = B(k).E(b);
            
            cnt=cnt+1;
        end
        ck=ck+1;
    end
end