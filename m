From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: dmesg: "CIFS VFS: Unexpected lookup error -26"
Date: Sat, 14 Sep 2013 07:38:47 -0400
Message-ID: <20130914073847.075b1921@tlielax.poochiereds.net>
References: <op.w295luvq07ery2@nmr100.nioch.nsc.ru>
	<20130912055839.5ca8e8c3@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Andrey Shernyukov" <andreysh-0G7livjLyD/FOEHFb8W2jw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130912055839.5ca8e8c3-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 12 Sep 2013 05:58:39 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, 12 Sep 2013 11:04:32 +0700
> "Andrey Shernyukov" <andreysh-0G7livjLyD/FOEHFb8W2jw@public.gmane.org> wrote:
> 
> > Hi,
> > "CIFS VFS: Unexpected lookup error -26" message appears every time when I  
> > enter into the root directory of win-share (C$) containing the  
> > pagefile.sys and hibernate.sys.
> > 
> > ll /media/share
> > .....
> > -?????????? ? ?      ?          ?            ? hiberfil.sys
> > -rwxr-xr-x. 1 andrew root     609 Sep 30  2008 inclick.txt
> > -r-xr-xr-x. 1 andrew root       0 Apr 13  2008 IO.SYS
> > -r-xr-xr-x. 1 andrew root       0 Apr 13  2008 MSDOS.SYS
> > -r-xr-xr-x. 1 andrew root  251152 Oct 20  2008 ntldr
> > -?????????? ? ?      ?          ?            ? pagefile.sys
> > ...
> > 
> 
> Most likely you're getting a NT_STATUS_SHARING_VIOLATION error back
> from the server which is preventing you from fetching information about
> those files. It should be harmless, but there's little we can do to
> prevent that.
> 
> Arguably, the client shouldn't be spamming the logs with messages about
> that however.
> 
> 
> > cat /proc/mounts | grep share
> > //***.***.***.***/c$/ /media/share cifs  
> > rw,relatime,sec=ntlm,cache=loose,unc=\\***.***.***.***\c$,username=andrew,uid=500,forceuid,gid=0,noforcegid,addr=***.***.***.***,file_mode=0755,dir_mode=0755,nounix,serverino,rsize=16384,wsize=65536,actimeo=1  
> > 0 0
> > 
> > cat /etc/fstab
> > //***.***.***.***/c$ /media/share/ cifs  
> > uid=andrew,nounix,_netdev,credentials=/root/securedir/secfile    0 0
> > 
> > uname -a
> > Linux ***.***.***.*** 2.6.32-358.18.1.el6.i686 #1 SMP Wed Aug 28 14:27:42  
> > UTC 2013 i686 i686 i386 GNU/Linux
> > 
> > /sbin/modinfo cifs
> > filename:        
> > /lib/modules/2.6.32-358.18.1.el6.i686/kernel/fs/cifs/cifs.ko
> > version:        1.68
> > description:    VFS to access servers complying with the SNIA CIFS  
> > Specification e.g. Samba and Windows
> > license:        GPL
> > author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > srcversion:     15D320AAB626CCD8C6ADAD3
> > depends:
> > vermagic:       2.6.32-358.18.1.el6.i686 SMP mod_unload modversions 686
> > parm:           CIFSMaxBufSize:Network buffer size (not including header).  
> > Default: 16384 Range: 8192 to 130048 (int)
> > parm:           cifs_min_rcv:Network buffers in pool. Default: 4 Range: 1  
> > to 64 (int)
> > parm:           cifs_min_small:Small network buffers in pool. Default: 30  
> > Range: 2 to 256 (int)
> > parm:           cifs_max_pending:Simultaneous requests to server. Default:  
> > 50 Range: 2 to 256 (int)
> > parm:           echo_retries:Number of echo attempts before giving up and  
> > reconnecting server. Default: 5. 0 means never reconnect. (ushort)
> > 
> 
> 
> 

One thing that's interesting is that you apparently got information
about those files in the FIND_FIRST/NEXT response, but when you went to
go query info about them you likely got the NT_STATUS_SHARING_VIOLATION
error. Would it be possible to get a network capture while you run the
above command? Instructions on how to do that are here:

    https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Wire_Captures

I've had the lingering idea for a while that we ought to switch the
lookup code to use FIND_FIRST exclusively, since some infolevels give
you the inode number without having to send a second call. Doing that
might also avoid the error in this situation as well.


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
