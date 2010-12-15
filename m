From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs mount port issue
Date: Wed, 15 Dec 2010 06:54:42 -0500
Message-ID: <20101215065442.5d33774b@tlielax.poochiereds.net>
References: <AANLkTinv12_2k0J91f1Ub9HC1E34PA+FjLACuUmxSYts@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: varad gupta <postfix.vbg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinv12_2k0J91f1Ub9HC1E34PA+FjLACuUmxSYts-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 15 Dec 2010 09:33:05 +0530
varad gupta <postfix.vbg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi
> 
> I need to mount various smb exported shares (ssh forwarded on
> different ports) on a RHEL 5.4 host. Details of the host are =>
> ==========================================================================================================
> [vbg@mail ~]$ uname -r
> 2.6.18-164.el5
> 
> [vbg@mail ~]$ rpm -qa | grep samba
> samba-common-3.0.33-3.14.el5
> samba-client-3.0.33-3.14.el5
> 
> [vbg@mail ~]$ cat /etc/redhat-release
> Red Hat Enterprise Linux Server release 5.4 (Tikanga)
> 
> [root@mail ~]# modinfo cifs
> filename:       /lib/modules/2.6.18-164.el5/kernel/fs/cifs/cifs.ko
> version:        1.57RH
> description:    VFS to access servers complying with the SNIA CIFS
> Specification e.g. Samba and Windows
> license:        GPL
> author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> srcversion:     7850E473E371E5343DDEC5B
> depends:
> vermagic:       2.6.18-164.el5 SMP mod_unload 686 REGPARM 4KSTACKS gcc-4.1
> parm:           CIFSMaxBufSize:Network buffer size (not including
> header). Default: 16384 Range: 8192 to 130048 (int)
> parm:           cifs_min_rcv:Network buffers in pool. Default: 4
> Range: 1 to 64 (int)
> parm:           cifs_min_small:Small network buffers in pool. Default:
> 30 Range: 2 to 256 (int)
> parm:           cifs_max_pending:Simultaneous requests to server.
> Default: 50 Range: 2 to 256 (int)
> module_sig:    883f3504a8b7a0d18758d6145e112399509e3d81c22fa0b2255eabf4fbaa9ab07acd3899236f0a0b8e362c9a2d5c76e95982b9197944e40d7a4a6
> 
> ==========================================================================================================
> 
> Problem =>
> 
> When a different port is specified, mount.cifs does not contact that port =>
> 
> ======================================================================================
> [root@mail ~]# mount -t cifs //localhost/public /home/vbg/MyShares -o
> "username=vbg,ip=127.0.0.1,port=4033"
> Password:
> mount error 111 = Connection refused
> Refer to the mount.cifs(8) manual page (e.g.man mount.cifs)
> =========================================================================================
> 
> Problem for a single mount has been solved by using iptables =>
> 
> iptables -t nat -A OUTPUT -d 127.0.0.1 -p tcp --dport 445 -j REDIRECT
> --to-ports 4033
> ===========================================================================================
> 
> But I have various shares at various ssh forwarded ports that
> mount.cifs needs to mount.
> 
> Is is a problem with "mount.cifs.c" (samba-client-3.0.33-3.14.el5) or
> with cifs.ko (kernel-2.6.18-164.el5)
> 
> Any help and relevant patches, pointers would be deeply appreciated.
> 

That would be a kernel bug, and it should be fixed in RHEL5.5.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
