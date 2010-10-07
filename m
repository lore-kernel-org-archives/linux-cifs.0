From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: on multiuser mount, set ownership to
 current_fsuid/current_fsgid (try #5)
Date: Thu, 7 Oct 2010 13:48:28 -0500
Message-ID: <AANLkTim8Bj5k2hjrD18MG4GgCAGG=Mfm29vrqwfyVAyY@mail.gmail.com>
References: <1286477188-26681-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286477188-26681-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks - as I had commented before, I think this will help a few cases
where admin has to be override uid and mode to get apps to work.

On Thu, Oct 7, 2010 at 1:46 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> ...when unix extensions aren't enabled. This makes everything on the
> mount appear to be owned by the current user.
>
> This version of the patch differs from previous versions however in t=
hat
> the admin can still force the ownership of all files to appear as a
> single user via the uid=3D/gid=3D options.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/inode.c | =A0 10 ++++++++++
> =A01 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index dcd0886..7cf3d93 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1761,11 +1761,21 @@ check_inval:
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOU=
NT_MULTIUSER) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !tcon->unix_ext) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!cifs_sb->mnt_uid)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->u=
id =3D current_fsuid();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!cifs_sb->mnt_uid)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->g=
id =3D current_fsgid();
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
