From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Consolidate error handling for cifs_invalidate_mapping
Date: Thu, 24 Mar 2011 14:56:50 -0500
Message-ID: <AANLkTikg69J4rtufrdAaFUi6S6WrTzub0Tr5HKL_VrVx@mail.gmail.com>
References: <1300977587-8218-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300977587-8218-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Mar 24, 2011 at 9:39 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> Base of approach for splitting all calls that uses cifs_invalidate_ma=
pping
> (or cifs_revalidate_dentry, cifs_revalidate_file) into two groups:
> 1) aware about -EBUSY error code and report it back (cifs_d_revalidat=
e,
> cifs_strict_fsync, cifs_file_strict_mmap);
> 2) don't do it (cifs_getattrs, cifs_lseek).
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index adb6324..d3abfc5 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1683,27 +1683,25 @@ cifs_inode_needs_reval(struct inode *inode)
> =A0/*
> =A0* Zap the cache. Called when invalid_mapping flag is set.
> =A0*/
> -void
> +int
> =A0cifs_invalidate_mapping(struct inode *inode)
> =A0{
> - =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 int rc =3D 0;
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cifs_i =3D CIFS_I(inode);
>
> - =A0 =A0 =A0 cifs_i->invalid_mapping =3D false;
> -
> =A0 =A0 =A0 =A0if (inode->i_mapping && inode->i_mapping->nrpages !=3D=
 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* write back any cached data */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D filemap_write_and_wait(inode->i=
_mapping);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mapping_set_error(inode->i_mapping, rc=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D invalidate_inode_pages2(inode->=
i_mapping);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: could no=
t invalidate inode %p", __func__,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_i->invalid_mapping=
 =3D true;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: could not =
invalidate inode %p", __func__,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_i->invalid_mapping =3D (rc !=3D 0)=
 ? true : false;
> =A0 =A0 =A0 =A0}

aren't you setting invalid_mapping twice (the first one is redundant)?


> =A0int cifs_revalidate_file(struct file *filp)
> @@ -1722,7 +1720,7 @@ int cifs_revalidate_file(struct file *filp)
>
> =A0check_inval:
> =A0 =A0 =A0 =A0if (CIFS_I(inode)->invalid_mapping)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -1764,7 +1762,7 @@ int cifs_revalidate_dentry(struct dentry *dentr=
y)
>
> =A0check_inval:
> =A0 =A0 =A0 =A0if (CIFS_I(inode)->invalid_mapping)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>
> =A0 =A0 =A0 =A0kfree(full_path);
> =A0 =A0 =A0 =A0FreeXid(xid);
> @@ -1776,7 +1774,15 @@ int cifs_getattr(struct vfsmount *mnt, struct =
dentry *dentry,
> =A0{
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_sb)=
;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb=
);
> - =A0 =A0 =A0 int err =3D cifs_revalidate_dentry(dentry);
> + =A0 =A0 =A0 int err;
> +
> + =A0 =A0 =A0 err =3D cifs_revalidate_dentry(dentry);
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* We only need to get file attributes and don't need=
 to
> + =A0 =A0 =A0 =A0* aware about busy pages (-EBUSY error code).
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (err =3D=3D -EBUSY)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D 0;
>
> =A0 =A0 =A0 =A0if (!err) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0generic_fillattr(dentry->d_inode, stat=
);

With this change couldn't we accidently return a temporary write error
(ENOSPC for example or EACCESS) when revalidating a file - which the
caller is not expecting (getattr should only return errors if it can't
get the attributes)

--=20
Thanks,

Steve
