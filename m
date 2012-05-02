From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs - check S_AUTOMOUNT in revalidate
Date: Wed, 2 May 2012 07:26:36 -0400
Message-ID: <20120502072636.5fcecd3f@corrin.poochiereds.net>
References: <20120427081815.4478.26011.stgit@perseus.themaw.net>
	<CAH2r5ms7Xa5UXg-iw9QWG7u32nmDEneh0bHBM5d1kv4i-Oi_vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms7Xa5UXg-iw9QWG7u32nmDEneh0bHBM5d1kv4i-Oi_vA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 1 May 2012 22:23:37 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> You may have corrupted the patch by cut&paste.  Would you resend it?
> Checkpatch fails repeatedly with errors like:
>=20
> ERROR: trailing whitespace
> #84: FILE: fs/cifs/dir.c:671:
> +^I^I^I * If the inode wasn't known to be a dfs entry when^M$
>=20

Hmmm...the only checkpatch warnings I saw were these trivial ones,
which it looks to be getting out of the header of the email.

-------------------[snip]------------------

$ ./scripts/checkpatch.pl \[PATCH\]\ cifs\ -\ check\ S_AUTOMOUNT\ in\ r=
evalidate=20
WARNING: Use a single space after To:
#47:=20
To:	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

WARNING: Use a single space after Cc:
#48:=20
Cc:	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,

total: 0 errors, 2 warnings, 24 lines checked

[PATCH] cifs - check S_AUTOMOUNT in revalidate has style problems, plea=
se review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
-------------------[snip]------------------

I don't see any trailing whitespace.

In any case, I went ahead and pushed it to my cifs-3.4 branch if you
want to just cherry-pick it from there...

>=20
> On Fri, Apr 27, 2012 at 3:18 AM, Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org> wrote:
> > When revalidating a dentry, if the inode wasn't known to be a dfs
> > entry when the dentry was instantiated, such as when created via
> > ->readdir(), the DCACHE_NEED_AUTOMOUNT flag needs to be set on the
> > dentry in ->d_revalidate().
> >
> > The false return from cifs_d_revalidate(), due to the inode now
> > being marked with the S_AUTOMOUNT flag, might not invalidate the
> > dentry if there is a concurrent unlazy path walk. This is because
> > the dentry reference count will be at least 2 in this case causing
> > d_invalidate() to return EBUSY. So the asumption that the dentry
> > will be discarded then correctly instantiated via ->lookup() might
> > not hold.
> >
> > Signed-off-by: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
> > Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > ---
> >
> > =C2=A0fs/cifs/dir.c | =C2=A0 17 ++++++++++++-----
> > =C2=A01 files changed, 12 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> > index d172c8e..ec4e9a2 100644
> > --- a/fs/cifs/dir.c
> > +++ b/fs/cifs/dir.c
> > @@ -668,12 +668,19 @@ cifs_d_revalidate(struct dentry *direntry, st=
ruct nameidata *nd)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return 0;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/*
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* Forcibly invalidate automounting directory inodes
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* (remote DFS directories) so to have them
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* instantiated again for automount
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* If the inode wasn't known to be a dfs entry when
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* the dentry was instantiated, such as when created
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* via ->readdir(), it needs to be set now since the
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* attributes will have been updated by
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* cifs_revalidate_dentry().
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (IS_AUTOMOUNT(direntry->d_inode))
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (IS_AUTOMOUNT(direntry->d_inode) &&
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0!(direntry->d_flags & DCACHE_NEED_AUTOMOUNT)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&direntry->d_lock);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 direntry->d_flags |=3D DCACHE_NE=
ED_AUTOMOUNT;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&direntry->d_lock);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return 1;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
