From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 13/15] cifs: on multiuser mount, set ownership to
 current_fsuid/current_fsgid
Date: Thu, 23 Sep 2010 05:38:32 -0700
Message-ID: <20100923053832.3dc4c4e3@corrin.poochiereds.net>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
	<1285023704-2159-14-git-send-email-jlayton@redhat.com>
	<AANLkTimg9oBb7bKYEzKNbWiwqgSXXx-DQgrMY1VPiYVy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTimg9oBb7bKYEzKNbWiwqgSXXx-DQgrMY1VPiYVy@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 23 Sep 2010 01:19:23 -0500
Steve French <smfrench@gmail.com> wrote:

> Won't this overwrite the effect of the "uid" mount parameter?
>=20
> linux_uid is set at mount time to either current uid or what is passe=
d
> in on uid (if "uid" is specified on mount).   Your code seems to
> unconditionally change that to ignore the uid passed in or mount.
>=20

Does it make sense to present ownership of all files the same as the
uid=3D option in a multiuser mount scenario? Note that when it's not a
multiuser mount, the current behavior is unchanged.

> On Mon, Sep 20, 2010 at 6:01 PM, Jeff Layton <jlayton@redhat.com> wro=
te:
> > ...when unix extensions aren't enabled. This makes everything on
> > the mount appear to be owned by the current user.
> >
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> > =A0fs/cifs/inode.c | =A0 =A08 ++++++++
> > =A01 files changed, 8 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > index dcd0886..2256124 100644
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -1761,11 +1761,19 @@ check_inval:
> > =A0int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
> > =A0 =A0 =A0 =A0struct kstat *stat)
> > =A0{
> > + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_sb=
);
> > + =A0 =A0 =A0 struct cifsTconInfo *tcon =3D cifs_sb_master_tcon(cif=
s_sb);
> > =A0 =A0 =A0 =A0int err =3D cifs_revalidate_dentry(dentry);
> > +
> > =A0 =A0 =A0 =A0if (!err) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0generic_fillattr(dentry->d_inode, st=
at);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stat->blksize =3D CIFS_MAX_MSGSIZE;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stat->ino =3D CIFS_I(dentry->d_inode=
)->uniqueid;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MO=
UNT_MULTIUSER &&
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !tcon->unix_ext) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->uid =3D current=
_fsuid();
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->gid =3D current=
_fsgid();
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0return err;
> > =A0}
> > --
> > 1.7.2.3
> >
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
