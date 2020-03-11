function[Geom,Stiff,norm] = new_node_cord(Geom,Stiff);

Stiff.normnew = max(abs(Stiff.Delta));
Stiff.norm = abs((Stiff.normnew - Stiff.normold) / Stiff.normnew);
Stiff.normold = Stiff.normnew;

for ip = 1:Geom.npoin
    for j = 1:Stiff.ndofpn
        if Geom.LM_n(ip , j) < 0 || j == 3
            newLM_n(ip , j) = 0;
        else if Geom.LM_n(ip , j) > 0
                newLM_n(ip , j) = Stiff.Delta(Geom.LM_n(ip , j));
            end
        end
    end
end
%---------------------------------------------
nodecoor_new = zeros(Geom.npoin , Stiff.ndofpn - 1);
for i = 1 : Geom.npoin
    for j = 1 : Stiff.ndofpn-1
        nodecoor_new(i , j) = newLM_n(i , j);
        Geom.New_nodecoor(i , j) = Geom.nodecoor(i , j) + nodecoor_new(i , j);
    end
end
%---------------------------------------------
% elemcood_new update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    elemcoor_new(ielem , :) = [Geom.New_nodecoor(Geom.lnods(ielem , 1) , :),...
        Geom.New_nodecoor(Geom.lnods(ielem , 2) , :)];

Geom.nodecoor=Geom.New_nodecoor;

  Geom.elemcoor(ielem,:) = [Geom.nodecoor(Geom.lnods(ielem,1),:),...
        Geom.nodecoor(Geom.lnods(ielem,2),:)];
end
end

