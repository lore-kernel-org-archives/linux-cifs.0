From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Add rwpidforward mount option
Date: Mon, 2 May 2011 18:14:25 +0400
Message-ID: <BANLkTinLSgzXxL6nAb1rvSaRZ9zt5fHG5g@mail.gmail.com>
References: <1303392395-9217-1-git-send-email-piastry@etersoft.ru>
	<1303392395-9217-2-git-send-email-piastry@etersoft.ru>
	<20110429102213.3c8bdb33@corrin.poochiereds.net>
	<BANLkTi=JihA=TjEo6J5o6oR7rcw4LtpSxw@mail.gmail.com>
	<20110502081335.6cbe8222@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110502081335.6cbe8222-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/2 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Fri, 29 Apr 2011 18:41:54 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2011/4/29 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
>> > On Thu, 21 Apr 2011 17:26:35 +0400
>> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>> >
>> >> Add rwpidforward mount option that switches on a mode when we for=
ward
>> >> pid of a process who opened a file to any read and write operatio=
n.
>> >>
>> >> This can prevent applications like WINE from failing on read or w=
rite
>> >> operation on a previously locked file region from the same netfd =
from
>> >> another process if we use mandatory brlock style.
>> >> It is actual for WINE because during a run of WINE program two pr=
ocesses
>> >> work on the same netfd - share the same file struct between sever=
al VFS
>> >> fds:
>> >> 1) WINE-server does open and lock;
>> >> 2) WINE-application does read and write.
>> >>
>> >
>> > I guess I still don't quite get it. Why not always forward the pid
>> > unconditionally?
>> >
>> > For wine, you want to forward the pid in order to emulate windows
>> > locking semantics. But always forwarding the pid seems like it wou=
ld
>> > give you more unix-like semantics when locking unix applications,
>> > right? IOW, you'd be less likely to block in a read or write opera=
tion.
>> >
>> > Can you give an example of some use case that would break if you w=
ere
>> > to do this unconditionally?
>>
>> Ok. Let's predict:
>> 1) we negotiate mandatory locking semantic.
>> 2) we have a file opened my process 'A'.
>> 3) we do fork() - process 'B' is born and inherits a file.
>> 4) process 'A' set an exclusive lock on a file (from start to end)
>> 5) process 'B' write to a file and succeed if we forward pid
>> unconditionally in this case. - that's wrong according to mandatory
>> locking semantic
>> (http://msdn.microsoft.com/en-us/library/aa365202(v=3Dvs.85).aspx)
>>
>> So, at least we don't need to forward pid if we negotiate Windows
>> locking style. As for POSIX - I think that is not affect anything
>> because we work with advisory locking style and don't care about suc=
h
>> things at all. So, that's why we need it as separate mount option th=
at
>> switches specific behavior for application like WINE (or any other
>> client/server applications that send fd though a pipe or a socket an=
d
>> use a client for i/o operations and a server - to open and lock).
>>
>
> Yuck. It's pretty icky that we have to have 2 separate sets of behavi=
or
> here to work around a single application. I can't help but think that
> there must be a better way to do this.
>
> That said, I won't stand in the way of this patch if it's really the
> only option. Also, did you want to send a patch for the mount.cifs
> manpage to document this?
>
> Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Yes, as soon as these patches are applied, I will provide a patch for m=
anpage!

--=20
Best regards,
Pavel Shilovsky.
