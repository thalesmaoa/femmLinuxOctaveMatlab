function openfemm(fn)
    global ifile ofile HandleToFEMM

    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    isWindows = ispc;
    
    if isOctave
        rootdir=tilde_expand('~/.wine/drive_c/femm42/bin/');
    else
        rootdir='~/.wine/drive_c/femm42/bin/';
    end
        
    try
        pkg load windows
    catch
    end
   
    if (exist('actxserver') & isWindows)
        HandleToFEMM=actxserver('femm.ActiveFEMM');
        callfemm([ 'setcurrentdirectory(' , quote(pwd) , ')' ]);
    else
        % define temporary file locations
        ifile=[rootdir,'ifile.txt'];
        ofile=[rootdir,'ofile.txt'];

        % test to see if there is already a femm process open
        try
            [fid,msg]=fopen(ifile,'wt');
        catch
            [fid,msg]=fopen(ifile,'w');
        end
        fprintf(fid,'flput(0)');
        fclose(fid);
        pause(0.25);
        try
            [fid,msg]=fopen(ofile,'rt');
        catch
            [fid,msg]=fopen(ofile,'r');
        end
        if (fid==-1)
            %unlink(ifile);
            delete(ifile);
            if (~isOctave)
                system(['wine ',rootdir,'femm.exe -filelink &']);
            else
                system(['wine "',rootdir,'femm.exe" -filelink'],0,'async');
            end
        else
            fclose(fid);
            %unlink(ofile);
            delete(ofile);
            disp('FEMM is already open');
        end
    end

   % make sure that FEMM isn't in FEMM 4.0 compatibility mode,
   % otherwise some commands won't work right
   callfemm('setcompatibilitymode(0)');
