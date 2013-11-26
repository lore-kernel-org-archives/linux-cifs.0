From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Required key not available?
Date: Mon, 25 Nov 2013 21:52:41 -0500
Message-ID: <20131125215241.49faa310@corrin.poochiereds.net>
References: <CAPpy_fE=UgnVyUYA7spC7_rdPOvqeJYirKZk=CqqFcoe4e033w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "pisymbol ." <pisymbol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPpy_fE=UgnVyUYA7spC7_rdPOvqeJYirKZk=CqqFcoe4e033w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 25 Nov 2013 17:41:43 -0500
"pisymbol ." <pisymbol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hoping this is the right list after Googling for quite a while.
> 
> I am trying to mount a CIFS share on a Windows 7 SP1 using Kerberos
> but no matter what I try, it fails with this:
> 
> # mount.cifs -o sec=krb5 //tilt.quest.com/Alex_Documents /mnt
> mount error(126): Required key not available
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> 
> # uname -a
> Linux agalloch 2.6.34.9-69.ie5.fc13.x86_64 #1 SMP Sun Aug 14 22:10:19
> EDT 2011 x86_64 x86_64 x86_64 GNU/Linux
> 
> # cat /etc/redhat-release
> Fedora release 13 (Goddard)
> 
> # mount.cifs -V
> mount.cifs version: 4.7
> 
> # klist -e
> Ticket cache: FILE:/tmp/krb5cc_0
> Default principal: Administrator-LHiAKXGUGmt8zQARNC3f2A@public.gmane.org
> 
> Valid starting     Expires            Service principal
> 11/25/13 17:21:23  11/26/13 03:21:25  krbtgt/QUEST.COM-LHiAKXGUGmt8zQARNC3f2A@public.gmane.org
>     renew until 12/02/13 17:21:23, Etype (skey, tkt): ArcFour with
> HMAC/md5, ArcFour with HMAC/md5
> 
> Some more debugging output:
> 
> fs/cifs/sess.c: sess setup type 5
>  fs/cifs/cifs_spnego.c: key description =
> ver=0x2;host=tilt.quest.com;ip4=192.168.17.55;sec=krb5;uid=0x0;user=root;pid=0x4683
>  fs/cifs/sess.c: ssetup freeing small buf ffff88035ff8a700
>  CIFS VFS: Send error in SessSetup = -126
>  fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 14) rc = -126
>  CIFS VFS: cifs_mount failed w/return code = -126
> ...
> Slow work thread pool: Ready
>  CIFS VFS: Send error in SessSetup = -126
>  CIFS VFS: cifs_mount failed w/return code = -126
>  CIFS VFS: Send error in SessSetup = -126
>  CIFS VFS: cifs_mount failed w/return code = -126
>  CIFS VFS: Send error in SessSetup = -126
>  CIFS VFS: cifs_mount failed w/return code = -126
>  CIFS VFS: Send error in SessSetup = -126
>  CIFS VFS: cifs_mount failed w/return code = -126
>  CIFS VFS: Send error in SessSetup = -126
>  CIFS VFS: cifs_mount failed w/return code = -126
>  CIFS VFS: Send error in SessSetup = -126
>  CIFS VFS: cifs_mount failed w/return code = -126
>  CIFS VFS: Send error in SessSetup = -126
>  CIFS VFS: cifs_mount failed w/return code = -126
>  CIFS VFS: Send error in SessSetup = -126
>  CIFS VFS: cifs_mount failed w/return code = -126
>  CIFS VFS: signing required but server lacks support
>  CIFS VFS: cifs_mount failed w/return code = -95
>  CIFS VFS: Send error in SessSetup = -126
>  CIFS VFS: cifs_mount failed w/return code = -126
> 
> # cat /etc/request-keys.conf
> ...
> create     cifs.spnetgo     *    *         /usr/sbin/cifs.upcall %k

Check your spelling. Should be "cifs.spnego".

> create     dns_resolver    *     *         /usr/sbin/cifs.upcall %k
> 
> I can mount using Samba, I can mount using NTLMv1 and v2. But I can
> not mount using Kerberos. I can use kvno to get a host ticket with
> ease.
> 
> Folks, is there anything I'm missing here? Box is joined to AD and can
> query all day long.
> 
> Thanks!
> 
> -aps
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
