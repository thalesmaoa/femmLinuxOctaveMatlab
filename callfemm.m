% ActiveFEMM (C)2006 David Meeker, dmeeker@ieee.org

function z=callfemm(x)
    global ifile ofile HandleToFEMM

isWindows = ispc;
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

if (exist('actxserver') && isWindows)
	
	z=invoke(HandleToFEMM,'mlab2femm',x);
	if (length(z)~=0)
    	if (z(1)=='e')
        	error(sprintf('FEMM returns:\n%s',z));
    	else
        	z=strrep(z,'I','i');
       	 	z=eval(z);
    	end
	end

else

    % Form that I'd previously used in Octave:
	try
    	[fid,msg]=fopen(ifile,'wt');
	catch
		[fid,msg]=fopen(ifile,'w');
	end
    fprintf(fid,'flput(%s)',x);
    fclose(fid);
    
    if (isOctave)
        do
            do
			    try
	                [fid,msg]=fopen(ofile,'rt');
			    catch
				    [fid,msg]=fopen(ofile,'r');
			    end
                if (fid==-1) pause(0.001); end
            until (fid~=-1)
            u=fgets(fid);
            fclose(fid);
        until (u~=-1)
        z=eval(u);
    else
	    u=-1; fid = -1;
        while (u ==-1)
            while (fid ==-1)
                try
	                [fid, msg]=fopen(ofile,'rt');
			    catch
				    [fid, msg]=fopen(ofile,'r');
			    end
                if (fid==-1) 
                    pause(0.001); 
                end
            end
            u=fopen(fid);
            fclose(fid);
        end
        z=(u);
    end
    pause(0.001);
    delete(ofile);
    %z=eval(u);

end

