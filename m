From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: A problem of cifs performance
Date: Sat, 27 Jul 2013 06:31:37 -0400
Message-ID: <20130727063137.55590c81@tlielax.poochiereds.net>
References: <CALBiAX=iEAff6q-zhtW_hxDVYGFMzPmr0QDVMztW6JevNi4CAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?5ZGo5Lyf5p2w?= <zhou.weijie-9ato6ouKlQJBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALBiAX=iEAff6q-zhtW_hxDVYGFMzPmr0QDVMztW6JevNi4CAw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 27 Jul 2013 09:57:46 +0800
=E5=91=A8=E4=BC=9F=E6=9D=B0 <zhou.weijie-9ato6ouKlQJBDgjK7y7TUQ@public.gmane.org> wrote:

> Dear Sir:
>=20
>   Situation=EF=BC=9A
>   I create a share folder on windows 7,then I mount it via Linux.
>   I copy a file from the folder to Linux,but the max read rate is
> 28MB/s and the write rate can be 110MB/s .
>   I try to mount cifs by changing rsize ,but it can't be faster.
>   I don't know why the read rate is unusual?
>=20
>   Environment=EF=BC=9A
>   1.RHEL 6.2=EF=BC=9A2.6.32-220.el6.x86_64
>   2.CIFS version=EF=BC=9A1.68
>   3.mount.cifs version=EF=BC=9A4.8.1
>=20

That kernel has a patchset that adds some asynchronous write
capability, but does not yet have the patches that add asynchronous
(and larger) read capability. I know that Sachin has backported those
for RHEL6.5. When that kernel is released (another several months or
so?), read performance should substantially improve.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
