From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate error up to the caller during get/set
 acls
Date: Tue, 9 Nov 2010 13:56:40 -0500
Message-ID: <20101109135640.77c89c58@corrin.poochiereds.net>
References: <1289313302-31064-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101109124033.28393639@tlielax.poochiereds.net>
	<AANLkTikgu1kS0hR3ENb6=v1YLOELR2tKomaAu7T_ViAm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikgu1kS0hR3ENb6=v1YLOELR2tKomaAu7T_ViAm-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 9 Nov 2010 12:52:16 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Nov 9, 2010 at 11:40 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Tue, =A09 Nov 2010 08:35:02 -0600
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >>
> >> Modify get/set_cifs_acl* calls to reutrn error code and percolate =
the
> >> error code up to the caller.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsacl.c | =A0 46 ++++++++++++++++++++++++++++++------=
----------
> >> =A01 files changed, 30 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> >> index c9b4792..003588a 100644
> >> --- a/fs/cifs/cifsacl.c
> >> +++ b/fs/cifs/cifsacl.c
> >> @@ -568,8 +568,11 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(=
struct cifs_sb_info *cifs_sb,
> >>
> >> =A0 =A0 =A0 cifs_put_tlink(tlink);
> >>
> >> - =A0 =A0 cFYI(1, "GetCIFSACL rc =3D %d ACL len %d", rc, *pacllen)=
;
> >> - =A0 =A0 return pntsd;
> >> + =A0 =A0 cFYI(1, "%s: rc =3D %d ACL len %d", __func__, rc, *pacll=
en);
> >> + =A0 =A0 if (rc)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(rc);
> >> + =A0 =A0 else
> > =A0 =A0 =A0 =A0^^^^
> > =A0 =A0 =A0 =A0This else isn't needed
> >
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return pntsd;
> >> =A0}
> >>
> >> =A0static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_in=
fo *cifs_sb,
> >> @@ -591,19 +594,19 @@ static struct cifs_ntsd *get_cifs_acl_by_pat=
h(struct cifs_sb_info *cifs_sb,
> >> =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, READ_CO=
NTROL, 0,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fid, &oplock, NULL=
, cifs_sb->local_nls,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_f=
lags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> >> - =A0 =A0 if (rc) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Unable to open file to get AC=
L");
> >> - =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> >> + =A0 =A0 if (!rc) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBGetCIFSACL(xid, tcon, fid,=
 &pntsd, pacllen);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBClose(xid, tcon, fid);
> >> =A0 =A0 =A0 }
> >>
> >> - =A0 =A0 rc =3D CIFSSMBGetCIFSACL(xid, tcon, fid, &pntsd, pacllen=
);
> >> - =A0 =A0 cFYI(1, "GetCIFSACL rc =3D %d ACL len %d", rc, *pacllen)=
;
> >> -
> >> - =A0 =A0 CIFSSMBClose(xid, tcon, fid);
> >> - out:
> >> =A0 =A0 =A0 cifs_put_tlink(tlink);
> >> =A0 =A0 =A0 FreeXid(xid);
> >> - =A0 =A0 return pntsd;
> >> +
> >> + =A0 =A0 cFYI(1, "%s: rc =3D %d ACL len %d", __func__, rc, *pacll=
en);
> >> + =A0 =A0 if (rc)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(rc);
> >> + =A0 =A0 else
> > =A0 =A0 =A0 =A0^^^^
> > =A0 =A0 =A0 =A0Also not needed...
> >
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return pntsd;
> >> =A0}
> >>
> >> =A0/* Retrieve an ACL from the server */
> >> @@ -711,12 +714,18 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_=
sb, struct cifs_fattr *fattr,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pntsd =3D get_cifs_acl(cifs_sb, inode,=
 path, &acllen);
> >>
> >> =A0 =A0 =A0 /* if we can retrieve the ACL, now parse Access Contro=
l Entries, ACEs */
> >> - =A0 =A0 if (pntsd)
> >> + =A0 =A0 if (!pntsd)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: NULL sec desc", __func__)=
;
> > =A0 =A0 =A0 =A0^^^^^^^^
> > =A0 =A0 =A0 =A0Will this ever be a null pointer? I don't think it w=
ill.
> > =A0 =A0 =A0 =A0It's either going to be an ERR_PTR or a real cifs_nt=
sd.
> > =A0 =A0 =A0 =A0I think that check isn't needed.
>=20
> get_cifs_acl_by_pid/path can return NULL when the return thus
>=20
>         if (IS_ERR(tlink))
>                 return NULL;
>=20

That needs to be fixed too. Don't return NULL there, return
ERR_CAST(tlink) instead.
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
