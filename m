From: "Andrey Shernyukov" <andreysh-0G7livjLyD/FOEHFb8W2jw@public.gmane.org>
Subject: dmesg: "CIFS VFS: Unexpected lookup error -26"
Date: Thu, 12 Sep 2013 11:04:32 +0700
Message-ID: <op.w295luvq07ery2@nmr100.nioch.nsc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 8bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,
"CIFS VFS: Unexpected lookup error -26" message appears every time when I  
enter into the root directory of win-share (C$) containing the  
pagefile.sys and hibernate.sys.

ll /media/share
.....
-?????????? ? ?      ?          ?            ? hiberfil.sys
-rwxr-xr-x. 1 andrew root     609 Sep 30  2008 inclick.txt
-r-xr-xr-x. 1 andrew root       0 Apr 13  2008 IO.SYS
-r-xr-xr-x. 1 andrew root       0 Apr 13  2008 MSDOS.SYS
-r-xr-xr-x. 1 andrew root  251152 Oct 20  2008 ntldr
-?????????? ? ?      ?          ?            ? pagefile.sys
...

cat /proc/mounts | grep share
//***.***.***.***/c$/ /media/share cifs  
rw,relatime,sec=ntlm,cache=loose,unc=\\***.***.***.***\c$,username=andrew,uid=500,forceuid,gid=0,noforcegid,addr=***.***.***.***,file_mode=0755,dir_mode=0755,nounix,serverino,rsize=16384,wsize=65536,actimeo=1  
0 0

cat /etc/fstab
//***.***.***.***/c$ /media/share/ cifs  
uid=andrew,nounix,_netdev,credentials=/root/securedir/secfile    0 0

uname -a
Linux ***.***.***.*** 2.6.32-358.18.1.el6.i686 #1 SMP Wed Aug 28 14:27:42  
UTC 2013 i686 i686 i386 GNU/Linux

/sbin/modinfo cifs
filename:        
/lib/modules/2.6.32-358.18.1.el6.i686/kernel/fs/cifs/cifs.ko
version:        1.68
description:    VFS to access servers complying with the SNIA CIFS  
Specification e.g. Samba and Windows
license:        GPL
author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
srcversion:     15D320AAB626CCD8C6ADAD3
depends:
vermagic:       2.6.32-358.18.1.el6.i686 SMP mod_unload modversions 686
parm:           CIFSMaxBufSize:Network buffer size (not including header).  
Default: 16384 Range: 8192 to 130048 (int)
parm:           cifs_min_rcv:Network buffers in pool. Default: 4 Range: 1  
to 64 (int)
parm:           cifs_min_small:Small network buffers in pool. Default: 30  
Range: 2 to 256 (int)
parm:           cifs_max_pending:Simultaneous requests to server. Default:  
50 Range: 2 to 256 (int)
parm:           echo_retries:Number of echo attempts before giving up and  
reconnecting server. Default: 5. 0 means never reconnect. (ushort)

-- 
Thanks,
Andrey.
