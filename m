From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/4] cifs: pave way for change to "strictcache" by default
Date: Fri, 27 Apr 2012 16:28:19 +0400
Message-ID: <CAKywueSwx+HNSHLRQka9C6Z7FVnu7aOrUeXUDz05KT22jy0Vww@mail.gmail.com>
References: <1335524179-1671-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335524179-1671-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

27 =C1=D0=D2=C5=CC=D1 2012=9A=C7. 14:56 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=
=D8 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> cifs.ko currently does not follow the CIFS protocol as it should by
> default. The protocol specifies (paraphrasing) "Thou shalt not cache
> file data without an oplock." cifs.ko by default *does* do this howev=
er,
> opting for a more NFS-like cache coherency scheme. It caches file dat=
a
> in the pagecache, and invalidate it when the attributes look like the
> file has changed.
>
> Unfortunately, this can and does cause cache coherency problems. The
> kernel can end up buffering up writes for longer than it should. In
> particular, internal testing at RH with Samba/CTDB has shown cache
> coherency problems when we don't mount on the clients with
> strictcache:
>
> =9A =9Ahttps://bugzilla.redhat.com/show_bug.cgi?id=3D742314
>
> Up until now, we've shied away from changing this default primarily f=
or
> performance reasons. The code to handle uncached reads and writes was
> synchronous, and very slow. With the addition of async uncached write=
s
> in 3.4 and async uncached reads in 3.5, I think performance is good
> enough that we ought to change the defaults to be "strictcache" for
> better adherence to the protocol.
>
> This patchset begins this transition by cleaning up the mount options
> that we use to control the cache behavior, and adding some warnings
> about the impending behavior change. I'm proposing that we follow the
> kernel convention of warning for 2 releases about user-visible change=
s
> and then we'll make the switch in 3.7.
>
> At the same time, it corrects a problem with the current code. The
> different cache behaviors are not considered to be mutually exclusive
> even though they should be. If someone (for instance) specifies
> "strictcache" and "fsc" the results are poorly defined. The first
> patch corrects this.
>
> If this looks acceptable, I'll also plan to spin up a manpage patch
> to help document this change.
>
> Jeff Layton (4):
> =9Acifs: add a cache=3D option to better describe the different cache
> =9A =9Aflavors
> =9Acifs: add deprecation warnings to strictcache, forcedirectio, and =
fsc
> =9Acifs: display cache=3D option in /proc/mounts
> =9Acifs: add warning about change in default cache semantics in 3.7
>
> =9Afs/cifs/cifsfs.c =9A| =9A 22 +++++++++---
> =9Afs/cifs/connect.c | =9A 96 +++++++++++++++++++++++++++++++++++++++=
++++++++++++--
> =9A2 files changed, 109 insertions(+), 9 deletions(-)
>
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =9Ahttp://vger.kernel.org/majordomo-info.html

The patchset looks good and resonable.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
