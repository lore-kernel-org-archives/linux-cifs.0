From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: setuids/setgids by default
Date: Sun, 29 Apr 2012 08:52:51 +0400
Message-ID: <CAKywueQx59wbr9pnvS=q-EqT33vfL9pGuFQF3h94-nRBc_5BXA@mail.gmail.com>
References: <CAKywueSQQfzwkWgE33+w=y2pnQQd4nxhvJX71NaAa0E_BLAcbg@mail.gmail.com>
	<20120428080230.160c6b38@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120428080230.160c6b38-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/4/28 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Sat, 28 Apr 2012 14:42:35 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Hi!
>>
>> Now CIFS client doesn't enforce uid and gid permission from the
>> process that create file by default (new files are created with moun=
t
>> user permission) and it can be 'fixed' by setuids/setgids mount
>> option. Why this options should not be by default? I think it
>> contradict POSIX.
>>
>
> Welcome to the morass that we call "the cifs.ko permissions model".
>
> The reason we don't do that by default is because it doesn't work. Wh=
at
> happens is that the client does a unix SetPathInfo call to try and
> chown the file, but in =A0order to chown() a file on unix, you need
> superuser permissions.
>
> Once the session setup is done, the server daemon will usually setuid=
()
> itself to the user you're mounting as, and at that point you don't ha=
ve
> permissions to chown anymore.
>
> What "setuids" also does is to "fake up" the ownership of the inode
> temporarily just after creation. That's just a hack though -- as soon=
 as
> the attributes are fetched from the server again, that goes away, so
> results with that are inconsistent.
>
> Ha, and it looks like "setuids" is broken when you create files in
> cifs_lookup anyway! Maybe someone should fix that sometime...
>
> In any case, I maintain that the only *real* fix for all of these
> permissions problems is to both:
>
> 1) have users use the correct credentials when they talk to the serve=
r.
> Files get created with the correct ownership this way.
>
> 2) stop trying to enforce permissions on the client. It's racy and ju=
st
> gets in the way. Permissions can only be correctly enforced by the
> server.
>
> This is what the "multiuser" mount option does. If anything, I'd rath=
er
> see a transition to that being the default. It's the only sane
> solution, IMO.
>
> That said, if you want to do some cleanup work on the permissions mou=
nt
> options mess model, I'll be happy to help review it...
>
> FWIW, I gave a talk at sambaxp a couple of years ago that covered a l=
ot
> of the problems. I'd advise you to have a look at that before you spe=
nd
> too much time looking at this...
>
> =A0 =A0http://sambaxp.org/index.php?id=3D38
>
> ...see the talk on "Multi-session Linux CIFS".
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Ok, now I understand the problem, thanks. Seems multiuser is the best
we can do with it.

--=20
Best regards,
Pavel Shilovsky.
