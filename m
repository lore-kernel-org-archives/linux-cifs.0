From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] cifs: have cifs_cleanup_volume_info not take a double pointer
Date: Wed, 6 Jul 2011 18:13:23 +0400
Message-ID: <CAKywueRxEZ+Nt6nPi_Cx3+_GtKZU6eGOi_b8H8O0A5aufVcckQ@mail.gmail.com>
References: <1309954239-17345-1-git-send-email-jlayton@redhat.com>
	<1309954239-17345-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309954239-17345-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/7/6 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> ...as that makes for a cumbersome interface. Make it take a regular
> smb_vol pointer and rely on the caller to zero it out if needed.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 =A02 +-
> =A0fs/cifs/cifsproto.h | =A0 =A02 +-
> =A0fs/cifs/connect.c =A0 | =A0 10 +++-------
> =A03 files changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 35f9154..e11b831 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -713,7 +713,7 @@ cifs_do_mount(struct file_system_type *fs_type,
> =A0out_super:
> =A0 =A0 =A0 =A0deactivate_locked_super(sb);
> =A0out:
> - =A0 =A0 =A0 cifs_cleanup_volume_info(&volume_info);
> + =A0 =A0 =A0 cifs_cleanup_volume_info(volume_info);
> =A0 =A0 =A0 =A0return root;
>
> =A0out_mountdata:
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 257f312..53b1b13 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -154,7 +154,7 @@ extern int set_cifs_acl(struct cifs_ntsd *, __u32=
, struct inode *,
> =A0extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ci=
fs_sb_info *cifs_sb);
> =A0extern int cifs_match_super(struct super_block *, void *);
> -extern void cifs_cleanup_volume_info(struct smb_vol **pvolume_info);
> +extern void cifs_cleanup_volume_info(struct smb_vol *pvolume_info);
> =A0extern int cifs_setup_volume_info(struct smb_vol **pvolume_info,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ch=
ar *mount_data, const char *devname);
> =A0extern int cifs_mount(struct cifs_sb_info *, struct smb_vol *);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 44376ce..dd06407 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2831,14 +2831,11 @@ is_path_accessible(int xid, struct cifs_tcon =
*tcon,
> =A0}
>
> =A0void
> -cifs_cleanup_volume_info(struct smb_vol **pvolume_info)
> +cifs_cleanup_volume_info(struct smb_vol *volume_info)
> =A0{
> - =A0 =A0 =A0 struct smb_vol *volume_info;
> -
> - =A0 =A0 =A0 if (!pvolume_info || !*pvolume_info)
> + =A0 =A0 =A0 if (!volume_info)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>
> - =A0 =A0 =A0 volume_info =3D *pvolume_info;
> =A0 =A0 =A0 =A0kfree(volume_info->username);
> =A0 =A0 =A0 =A0kzfree(volume_info->password);
> =A0 =A0 =A0 =A0kfree(volume_info->UNC);
> @@ -2847,7 +2844,6 @@ cifs_cleanup_volume_info(struct smb_vol **pvolu=
me_info)
> =A0 =A0 =A0 =A0kfree(volume_info->iocharset);
> =A0 =A0 =A0 =A0kfree(volume_info->prepath);
> =A0 =A0 =A0 =A0kfree(volume_info);
> - =A0 =A0 =A0 *pvolume_info =3D NULL;
> =A0 =A0 =A0 =A0return;
> =A0}
>
> @@ -2990,7 +2986,7 @@ int cifs_setup_volume_info(struct smb_vol **pvo=
lume_info, char *mount_data,
> =A0 =A0 =A0 =A0*pvolume_info =3D volume_info;
> =A0 =A0 =A0 =A0return rc;
> =A0out:
> - =A0 =A0 =A0 cifs_cleanup_volume_info(&volume_info);
> + =A0 =A0 =A0 cifs_cleanup_volume_info(volume_info);
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> --
> 1.7.6
>
>

Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
