From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] Regression in mfsymlink handling introduced by "cifs:
 only set ops for inodes in I_NEW state"
Date: Wed, 7 Aug 2013 08:09:55 -0400
Message-ID: <20130807080955.1fdcf585@corrin.poochiereds.net>
References: <51F92F0B.7030504@cam.ac.uk>
	<5201089C.1010403@samba.org>
	<20130806105623.322d32a6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130806105623.322d32a6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 6 Aug 2013 10:56:23 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 06 Aug 2013 16:30:52 +0200
> "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>=20
> > Hi David,
> >=20
> > > The following commit included in 3.10, and copied to some table-s=
eries
> > > kernels:
> > >=20
> > >  commit: c2b93e0699723700f886ce17bb65ffd771195a6d
> > >  cifs: only set ops for inodes in I_NEW state
> > >=20
> > > ... causes a regression in mfsymlink handling under some circumst=
ances.
> > >=20
> > > Specifically, this patch modified cifs_fattr_to_inode() to only i=
nvoke
> > > cifs_set_ops() if that inode still had the I_NEW flag set --- pre=
venting
> > > an inode's ops-set from from being changed after it had been
> > > initialized, preventing an oops if another thread of execution wa=
s
> > > already chasing that pointer.
> > >=20
> > > However, mfsymlinks are also affected by this commit.  In the col=
d-cache
> > > case, a user invoking stat() on an mfsymlink will still see the c=
orrect
> > > results.  But, if the dentry cache is instead populated via
> > > cifs_readdir/filldir, then inode property population operates in =
a two
> > > stage mode:
> > >=20
> > >  - First, the inode is initialized as a regular file, with the
> > >    CIFS_FATTR_NEED_REVAL flag set.
> > >=20
> > >  - Later, when the file is stat()'d, then correct operation depen=
ds on
> > >    the (re)validation steps from being able to update the inode's
> > >    properties --- including the set of file operations permitted.
> > >=20
> > > (A comment explains:  "trying to get the type and mode can be slo=
w, so
> > >  just call those regular files for now, and mark for reval")
> > >=20
> > > With the above commit, this second revalidation step never update=
s the
> > > operations field, resulting in symlinks not having the readlink()=
, etc.
> > > functions correctly hooked up.
> >=20
> > > A na=C3=AFve fix-up is to modify the conditional to also permit (=
re)setting
> > > ops on S_IFLNK-mode files; however, I suspect a correct fix lies =
elsewhere?
> >=20
> > I guess 'if (inode->i_state & I_NEW)' should be changed to
> > 'if ((inode->i_state & I_NEW) || (fattr->cf_flags & CIFS_FATTR_NEED=
_REVAL))'
> >=20
> > Would that solve the problem?
> >=20
> > Jeff/Steve, any comment on this?
> >=20
> > metze
> >=20
>=20
> I don't think so...
>=20
> Once an inode's operations are set, you really don't want to go
> changing them. That opens the door for a malicious server to change t=
he
> file type out from under you and cause oopses. The bug report that
> Sachin worked on originally had such an oops. In that case it was
> caused by something else, but a malicious server could wreak similar
> havoc...
>=20
> The right solution is probably to ensure that the dentry fails
> d_revalidate if there's a chance it could turn out to be a mfsymlink.
> I think that the easiest way to ensure that would probably be to set =
the
> dentry->d_time to 0 in the readdir code.
>=20

Specifically, I think the logic in cifs_d_revalidate is just plain
wrong. Currently, the dentry->d_time check and the check for
lookupCacheEnabled is only done for negative dentries. Shouldn't that
be affecting positive dentries as well?

If so, then you could simply set the dentries that are possible
mfsymlinks with a d_time of 0. They'd fail revalidation at that
step and get recreated when you stat them.

Sachin, Steve, thoughts?
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
