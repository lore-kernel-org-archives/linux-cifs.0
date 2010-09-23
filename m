From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 13/15] cifs: on multiuser mount, set ownership to current_fsuid/current_fsgid
Date: Thu, 23 Sep 2010 01:19:23 -0500
Message-ID: <AANLkTimg9oBb7bKYEzKNbWiwqgSXXx-DQgrMY1VPiYVy@mail.gmail.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
	<1285023704-2159-14-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285023704-2159-14-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Won't this overwrite the effect of the "uid" mount parameter?

linux_uid is set at mount time to either current uid or what is passed
in on uid (if "uid" is specified on mount).   Your code seems to
unconditionally change that to ignore the uid passed in or mount.

On Mon, Sep 20, 2010 at 6:01 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> ...when unix extensions aren't enabled. This makes everything on
> the mount appear to be owned by the current user.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/inode.c | =A0 =A08 ++++++++
> =A01 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index dcd0886..2256124 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1761,11 +1761,19 @@ check_inval:
> =A0int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
> =A0 =A0 =A0 =A0struct kstat *stat)
> =A0{
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_sb);
> + =A0 =A0 =A0 struct cifsTconInfo *tcon =3D cifs_sb_master_tcon(cifs_=
sb);
> =A0 =A0 =A0 =A0int err =3D cifs_revalidate_dentry(dentry);
> +
> =A0 =A0 =A0 =A0if (!err) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0generic_fillattr(dentry->d_inode, stat=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stat->blksize =3D CIFS_MAX_MSGSIZE;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stat->ino =3D CIFS_I(dentry->d_inode)-=
>uniqueid;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUN=
T_MULTIUSER &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !tcon->unix_ext) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->uid =3D current_f=
suid();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->gid =3D current_f=
sgid();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return err;
> =A0}
> --
> 1.7.2.3
>
>



--=20
Thanks,

Steve
