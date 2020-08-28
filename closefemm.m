% ActiveFEMM (C)2006 David Meeker, dmeeker@ieee.org

function closefemm()

  global HandleToFEMM
  isWindows = ispc;
  
  if (exist('actxserver') && isWindows)
      global HandleToFEMM
      delete(HandleToFEMM);
      HandleToFEMM=0;
  else
      callfemm('quit()');
  end

