From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: regression with prefixpath mounts
Date: Tue, 9 Aug 2011 12:57:52 -0400
Message-ID: <20110809125752.661cf036@tlielax.poochiereds.net>
References: <20110804102932.4adf33bf@barsoom.rdu.redhat.com>
	<CAKywueQEP72GEWmG3pxC9G0YfNchKWm9=WjCaNZNQSfSUQ0isA@mail.gmail.com>
	<CAKywueSkf+5Sq9=nsfcwe2zohn1Nb_QmWmxaxCueVjEQ054YFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSkf+5Sq9=nsfcwe2zohn1Nb_QmWmxaxCueVjEQ054YFw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 9 Aug 2011 20:49:57 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/8/4 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > 2011/8/4 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> >> Hi Pavel,
> >>
> >> We have a bit of a problem...
> >>
> >> =C2=A0 =C2=A0https://bugzilla.redhat.com/show_bug.cgi?id=3D727834
> >>
> >> The shared superblock patches seem to have broken the ability to m=
ount
> >> directories that live under other directories to which the mountin=
g
> >> user doesn't have permissions.
> >>
> >> IOW, suppose we have this shared out:
> >>
> >> =C2=A0 =C2=A0/share/dir1/dir2
> >>
> >> ...if the permissions on dir1 don't allow the mounting user to acc=
ess
> >> it, then cifs_get_root will fail. We'll need to come up with a new
> >> scheme for handling this that doesn't require access to every comp=
onent
> >> of the prefixpath.
> >>
> >> I'm not sure what the right fix is here...we may need to come up w=
ith a
> >> scheme more like NFS does. It will alter the tree when it discover=
s
> >> that a root dir that it previously was working on is actually a su=
bdir
> >> of another mount.
> >>
> >> Thoughts?
> >> --
> >> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>
> >
> > Thanks for the report. I understand the problem, let me think how t=
o
> > fix it right.
> >
> > --
> > Best regards,
> > Pavel Shilovsky.
> >
>=20
> According to https://bugzilla.redhat.com/show_bug.cgi?id=3D727834, it
> seems to me that the problem is fixed. If the situation changes, let
> me know, please.
>=20

I suspect we still have a regression here. It seems possible that a
user might not have access to parent or grandparent directories of the
one that they want to mount. In that case, walking down the tree to the
vfsmount root may be problematic.

That said, I don't have a clear reproducer for this (nor the time or
inclination to come up with one).

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
