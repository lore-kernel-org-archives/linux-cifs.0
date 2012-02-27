From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: Fix mkdir/rmdir bug for the non-POSIX case
Date: Mon, 27 Feb 2012 15:22:42 -0500
Message-ID: <20120227152242.2945558a@tlielax.poochiereds.net>
References: <1329484410-30540-1-git-send-email-piastry@etersoft.ru>
	<20120221100006.7e43e8b9@tlielax.poochiereds.net>
	<CAKywueS0XKjuX_sLfb=Lhp=hLgrYpq7ndAtNGDjq1pFg16A7dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueS0XKjuX_sLfb=Lhp=hLgrYpq7ndAtNGDjq1pFg16A7dA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 25 Feb 2012 13:11:26 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2012/2/21 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > On Fri, 17 Feb 2012 16:13:30 +0300
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> Currently we do inc/drop_nlink for a parent directory for every
> >> mkdir/rmdir calls. That's wrong when Unix extensions are disabled
> >> because in this case a server doesn't follow the same semantic and
> >> returns the old value on the next QueryInfo request. As the result=
,
> >> we update our value with the server one and then decrement it on
> >> every rmdir call - go to negative nlink values.
> >>
> >> Fix this by removing inc/drop_nlink for the parent directory from
> >> mkdir/rmdir, setting it for a revalidation and ignoring NumberOfLi=
nks
> >> for directories when Unix extensions are disabled.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/inode.c | =C2=A0 28 +++++++++++++++++++---------
> >> =C2=A01 files changed, 19 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> >> index a5f54b7..745da3d 100644
> >> --- a/fs/cifs/inode.c
> >> +++ b/fs/cifs/inode.c
> >> @@ -534,6 +534,11 @@ cifs_all_info_to_fattr(struct cifs_fattr *fat=
tr, FILE_ALL_INFO *info,
> >> =C2=A0 =C2=A0 =C2=A0 if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fattr->cf_mode =3D=
 S_IFDIR | cifs_sb->mnt_dir_mode;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fattr->cf_dtype =3D=
 DT_DIR;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Server can ret=
urn wrong NumberOfLinks value for directories
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* when Unix exte=
nsions are disabled - fake it.
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fattr->cf_nlink =3D 2;
> >> =C2=A0 =C2=A0 =C2=A0 } else {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fattr->cf_mode =3D=
 S_IFREG | cifs_sb->mnt_file_mode;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fattr->cf_dtype =3D=
 DT_REG;
> >> @@ -541,9 +546,9 @@ cifs_all_info_to_fattr(struct cifs_fattr *fatt=
r, FILE_ALL_INFO *info,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* clear write bi=
ts if ATTR_READONLY is set */
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (fattr->cf_cif=
sattrs & ATTR_READONLY)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 fattr->cf_mode &=3D ~(S_IWUGO);
> >> - =C2=A0 =C2=A0 }
> >>
> >> - =C2=A0 =C2=A0 fattr->cf_nlink =3D le32_to_cpu(info->NumberOfLink=
s);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fattr->cf_nlink =3D le=
32_to_cpu(info->NumberOfLinks);
> >> + =C2=A0 =C2=A0 }
> >>
> >> =C2=A0 =C2=A0 =C2=A0 fattr->cf_uid =3D cifs_sb->mnt_uid;
> >> =C2=A0 =C2=A0 =C2=A0 fattr->cf_gid =3D cifs_sb->mnt_gid;
> >> @@ -1322,7 +1327,6 @@ int cifs_mkdir(struct inode *inode, struct d=
entry *direntry, umode_t mode)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> >> =C2=A0/*BB check (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID ) t=
o see if need
> >> =C2=A0 =C2=A0 =C2=A0 to set uid/gid */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 inc_nlink(inode);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cifs_unix_basic_to_fattr(&fattr, pInfo, cifs_sb);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cifs_fill_uniqueid(inode->i_sb, &fattr);
> >> @@ -1355,7 +1359,6 @@ mkdir_retry_old:
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 d_drop(direntry);
> >> =C2=A0 =C2=A0 =C2=A0 } else {
> >> =C2=A0mkdir_get_info:
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inc_nlink(inode);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (pTcon->unix_e=
xt)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D cifs_get_inode_info_unix(&newinode, full_path,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode->i_sb, xid);
> >> @@ -1436,6 +1439,11 @@ mkdir_get_info:
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0mkdir_out:
> >> + =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0* Force revalidate to get parent dir info wh=
en needed since cached
> >> + =C2=A0 =C2=A0 =C2=A0* attributes are invalid now.
> >> + =C2=A0 =C2=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 CIFS_I(inode)->time =3D 0;
> >> =C2=A0 =C2=A0 =C2=A0 kfree(full_path);
> >> =C2=A0 =C2=A0 =C2=A0 FreeXid(xid);
> >> =C2=A0 =C2=A0 =C2=A0 cifs_put_tlink(tlink);
> >> @@ -1475,7 +1483,6 @@ int cifs_rmdir(struct inode *inode, struct d=
entry *direntry)
> >> =C2=A0 =C2=A0 =C2=A0 cifs_put_tlink(tlink);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 if (!rc) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 drop_nlink(inode);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&dirent=
ry->d_inode->i_lock);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i_size_write(dire=
ntry->d_inode, 0);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 clear_nlink(diren=
try->d_inode);
> >> @@ -1483,12 +1490,15 @@ int cifs_rmdir(struct inode *inode, struct=
 dentry *direntry)
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> =C2=A0 =C2=A0 =C2=A0 cifsInode =3D CIFS_I(direntry->d_inode);
> >> - =C2=A0 =C2=A0 cifsInode->time =3D 0; =C2=A0 =C2=A0/* force reval=
idate to go get info when
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0needed */
> >> + =C2=A0 =C2=A0 /* force revalidate to go get info when needed */
> >> + =C2=A0 =C2=A0 cifsInode->time =3D 0;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 cifsInode =3D CIFS_I(inode);
> >> - =C2=A0 =C2=A0 cifsInode->time =3D 0; =C2=A0 =C2=A0/* force reval=
idate to get parent dir info
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0since cached search result=
s now invalid */
> >> + =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0* Force revalidate to get parent dir info wh=
en needed since cached
> >> + =C2=A0 =C2=A0 =C2=A0* attributes are invalid now.
> >> + =C2=A0 =C2=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 cifsInode->time =3D 0;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 direntry->d_inode->i_ctime =3D inode->i_ctime=
 =3D inode->i_mtime =3D
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 current_fs_time(i=
node->i_sb);
> >
> > Looks good.
> >
> > Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>=20
> Steve, what's about this patch? I think it should go to stable as wel=
l.
>=20

I think we probably ought to wait on stable. There is some (small)
potential for regression from this change. AFAIK, this is just fixing a
WARN_ON, so I think that there's no real urgency to stick it into
stable just yet.

We can always reconsider that later too if it turns out that there's
need to do so.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
