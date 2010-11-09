From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate errors up to the caller during get/set
 acls
Date: Tue, 9 Nov 2010 10:18:16 -0500
Message-ID: <20101109101816.6b7553b0@tlielax.poochiereds.net>
References: <1289231238-15203-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101108121310.78951ec1@tlielax.poochiereds.net>
	<AANLkTim-BWLSqKNZybQVxaff18X5WROrUGJcPTfqHMj3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim-BWLSqKNZybQVxaff18X5WROrUGJcPTfqHMj3-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 9 Nov 2010 08:42:04 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:


> >> =A0/* Retrieve an ACL from the server */
> >> -static struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_s=
b,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 struct inode *inode, const char *path,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 u32 *pacllen)
> >> +static int
> >> +get_cifs_acl(struct cifs_sb_info *cifs_sb, struct inode *inode,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 const char *path, u32 *pacllen, struct c=
ifs_ntsd **pntsd)
> >> =A0{
> >> - =A0 =A0 struct cifs_ntsd *pntsd =3D NULL;
> >> + =A0 =A0 int rc =3D 0;
> >> =A0 =A0 =A0 struct cifsFileInfo *open_file =3D NULL;
> >>
> >> =A0 =A0 =A0 if (inode)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 open_file =3D find_readable_file(CIFS_=
I(inode), true);
> > =A0 =A0 =A0 =A0^^^^^^^^^^
> > =A0 =A0 =A0 =A0This predates your patch, but under what conditions =
would we
> > =A0 =A0 =A0 =A0call this function without an inode? If you're clean=
ing up the
> > =A0 =A0 =A0 =A0prototype for this function, then I think there are =
some
> > =A0 =A0 =A0 =A0unneeded arguments here.
> >
>=20
> Jeff, not sure I understand this comment.  But I reposted this patch.
> I will address this issue as soon as I understand it.

I had originally thought that we'd never call get_cifs_acl with a NULL
inode pointer, but it looks like that can happen. I think that this
could stand some overhaul and in that process, we can eliminate some
unneeded arguments, but for now I don't think you can easily do it.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
