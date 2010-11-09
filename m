From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 2.6.37-rc1 kmemleak warnings when saving a file over cifs.
Date: Mon, 8 Nov 2010 22:12:11 -0600
Message-ID: <AANLkTindSKRu2SJoCwqwhdRmBaV-+oRDQ9fp9Cikh2_G@mail.gmail.com>
References: <AANLkTikCnK7YN9F3JOv0rVZt65iQ=v=YJ_ONOuwj_=9D@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikCnK7YN9F3JOv0rVZt65iQ=v=YJ_ONOuwj_=9D-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Nov 8, 2010 at 6:13 PM, Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
> Have just noticed these in the past few days, now running 2.6.37-rc1+
> Seems to be 1 logged per file save when using a text file with gedit =
over cifs.

Can you tell the called function in cifs_setattr_unix vs. cifs_setattr_=
nounix
(the former will usually be called when the server is Samba, the latter
when the server is Windows or NetApp).  What is the server type?

> unreferenced object 0xffff88022ee08b40 (size 32):
> =A0comm "gedit", pid 2524, jiffies 4300160388 (age 2633.655s)
> =A0hex dump (first 32 bytes):
> =A0 =A05c 2e 67 6f 75 74 70 75 74 73 74 72 65 61 6d 2d =A0\.goutputst=
ream-
> =A0 =A035 42 41 53 4c 56 00 de 09 00 00 00 2c 26 78 ee =A05BASLV.....=
=2E,&x.
> =A0backtrace:
> =A0 =A0[<ffffffff81504a4d>] kmemleak_alloc+0x2d/0x60
> =A0 =A0[<ffffffff81136e13>] __kmalloc+0xe3/0x1d0
> =A0 =A0[<ffffffffa0313db0>] build_path_from_dentry+0xf0/0x230 [cifs]
> =A0 =A0[<ffffffffa031ae1e>] cifs_setattr+0x9e/0x770 [cifs]
> =A0 =A0[<ffffffff8115fe90>] notify_change+0x170/0x2e0
> =A0 =A0[<ffffffff81145ceb>] sys_fchmod+0x10b/0x140
> =A0 =A0[<ffffffff8100c172>] system_call_fastpath+0x16/0x1b
> =A0 =A0[<ffffffffffffffff>] 0xffffffffffffffff

Didn't see anything obvious in cifs_setattr_unix on the kmalloc/kfree
of full_path,
but it will help when we know which path we are in.  We did make some r=
ecent
changes in 2.6.37 in file allocation.

--=20
Thanks,

Steve
