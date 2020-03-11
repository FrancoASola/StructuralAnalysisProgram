function dumpfile(FileName,Geom,Prop,Force,Stiff)
ls=findstr(FileName,'.inp');
fnm=[FileName(1:ls) 'mat'];
%%
nodcoord=Geom.nodecoor;
for i=1:Geom.nelem % Element info
ele(i).type='elasticbeamcolumn';
ele(i).('elasticbeamcolumn').sectag=i;
ele(i).('elasticbeamcolumn').snode=Geom.lnods(i,1);
ele(i).('elasticbeamcolumn').enode=Geom.lnods(i,2);
ele(i).('elasticbeamcolumn').L=Geom.L(i);
ele(i).('elasticbeamcolumn').CX=cos(Geom.alpha(i));
ele(i).('elasticbeamcolumn').Cy=sin(Geom.alpha(i));
ele(i).('elasticbeamcolumn').Gamma=Stiff.rotation(:,:,i);
% ele(i).('elasticbeamcolumn').static_local_nef=
% ele(i).('elasticbeamcolumn').static_global_nef=
% ele(i).('elasticbeamcolumn').inibarke=
ele(i).('elasticbeamcolumn').iniKe=Stiff.k(:,:,i);
ele(i).('elasticbeamcolumn').ele_nod_disp_global=Stiff.elem_delta_global(i,:)';%<<<<
ele(i).('elasticbeamcolumn').ele_nod_disp_local=Stiff.elem_delta_local(i,:)';%<<<<
ele(i).('elasticbeamcolumn').ele_nod_fos_local=Force.Plocal(:,i);
ele(i).('elasticbeamcolumn').ele_nod_fos_global=Force.Pglobe(:,i);
ele(i).('elasticbeamcolumn').sec=i;
mat(i).E=Prop.E(1);
sec(i).tag=i;
sec(i).type='General2D';
sec(i).mattag=i;
sec(i).A=Prop.A(1);
sec(i).Iz=Prop.Iz(i); 
end
%%
str.infile=FileName;
%str.Funit= 'kip'
%str.Lunit='in'
str.ndim=2;
str.ndofpn=Stiff.ndofpn;
str.analysis='Static';
%%%%%%%%%%str.constraints=
%%%str.nnode=4
str.nodcoord=Geom.nodecoor;
str.originalID=Geom.orig_ID;
str.ID=Geom.ID;
%%str.nfdofs=6
str.ntdofs=Stiff.nterm;
%%str.ncdofs=6
str.nele=Geom.nelem;
%%str.ndofpe=6
str.LM=Geom.LM;
%%%%str.elecoord
str.nsec=Geom.nelem;
str.nmat=Geom.nelem;
%%str.static_Pt=[6x1 double]
%%str.static_uu=[6x1 double]
%%str.nstatic=1
%%str.static_edf2nef=[6x1 double]
%%str.iniKtt=[6x6 double]
%%str.iniKtu=[6x6 double]
%%str.iniKut=[6x6 double]
%%str.iniKuu=[6x6 double]
%%str.iniKS=[12x12 double]
%%str.ut=[6x1 double]
%%str.reaction=[6x1 double]
%% forces are stored for Ptt, need to find the corresponding node and local dof
kk=0;
for i=1:Geom.nelem
    if Force.w(i)~=0
        kk=kk+1;
        forces{kk,1}=kk;
        forces{kk,2}='Static';
        forces{kk,3}{1}='eledist';
        forces{kk,3}{2}{1}=i;
        forces{kk,3}{2}{2}=2;
        forces{kk,3}{2}{3}=Force.w(i);
        %forces{3}{3}{kk}=2;
        %forces{3}{3}{kk}=Force.w(i);
    end
    if Force.Pelem(i)~=0
        kk=kk+1;
        forces{kk,1}=kk;
        forces{kk,2}='Static';
        forces{kk,3}{1}='elepoin';
        forces{kk,3}{2}{1}=Force.a(i);
        forces{kk,3}{3}{2}=Force.Pelem(i);
    end
end
for i=1:Stiff.number_gdofs % Nodal loads
    if Force.Pnods(i) ~=0
        for j=1:Geom.npoin
            for k=1:Stiff.ndofpn
                if i== Geom.ID(j,k)
                    kk=kk+1;
                    forces{1}=kk;
                    forces{2}='Static';
                    forces{kk,3}{1}='nodal';
                    forces{kk,3}{2}{1}=j;
                    forces{kk,3}{2}{2}=k;
                    forces{kk,3}{2}{3}=Force.Load(i);
                end
            end
        end
    end
end
save(fnm,'str','ele','mat','sec','forces')
end



%handles.str.nodcoord(id,1|2)
%handles.ele(ElementID).(ElementType).snode
%handles.ele(ElementID).(ElementType).enode
%handles.ele(ElementID).(eletype).L
%handles.ele(ElementID).type;
%handles.ele(ElementID).(eletype).Gamma;
%handles.ele(ElementID).elasticbeamcolumn.sectag;<<<<<<<<<<<<<<<
%handles.Results.NodalForce(enode,:)'
%handles.Results.NodalDisp(snode,:)'
%handles.mat(handles.sec(Section).mattag).E;
%handles.sec(Section).Iz;
%handles.forces{1,3}{fos_typ,2}{ele_fos,1}??
%elements = { {1, 'elasticbeamcolumn', 1, 2, 1, 1};};