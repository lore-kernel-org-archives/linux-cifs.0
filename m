From: Matt Garman <matthew.garman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: determine if junction for cifs mount of windows on linux?
Date: Tue, 10 Sep 2013 10:15:35 -0500
Message-ID: <20130910151535.GA16425@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


On Linux, I'm doing a CIFS mount of an entire Windows 7 hard drive
(aka C$).  My intent is to take regular whole-disk snapshot backups
of the drive using rsync.

For any "junction" on the Windows drive, I get permission denied on
the Linux CIFS mount side.  But using "ls", these junctions just
look like regular directories.  Is there any way to identify them as
junctions, so that I can exclude them from my rsync backup?  Or even
better, is there some way to have them not show up at all on the
CIFS mount?

A good example of this is "C:\Documents and Settings".  This is a
junction that maps to "C:\Users" on Windows 7.  I get permission
denied if I try to ls Documends and Settings, but I can ls Users
without any issue.

Here's my /etc/fstab entry:

//192.168.185.24/C$ /mnt/windows/matt   cifs //noperm,ro,ignorecase,credentials=/root/smb_auth.txt 0 0

Contents of /root/smb_auth.txt:
# cat /root/smb_auth.txt
username=WindowsUsername
password=WindowsPassword
domain=WindowsDomain
 
Running the mount command:

# mount -v matt
domain=WindowsDomain
mount.cifs kernel mount options:
ip=192.168.185.24,unc=\\192.168.185.24\C$,noperm,ignorecase,credentials=/root/smb_auth.txt,ver=1,user=WindowsUsername,domain=WindowsDomain,pass=********
  
Contents of /proc/mounts after being mounted:

# cat /proc/mounts | grep matt
//192.168.185.24/C$/ /mnt/windows/matt cifs ro,relatime,sec=ntlm,unc=\\192.168.185.24\C$,username=WindowsUser,domain=WindowsDomain,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.185.24,file_mode=0755,dir_mode=0755,nocase,serverino,noperm,rsize=16384,wsize=65536 0 0

Thanks,
Matt
