From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] cifs: fix expand_dfs_referral
Date: Wed, 6 Jul 2011 18:14:02 +0400
Message-ID: <CAKywueQfDc9X92R_OOP13qcJT5QoTE37Hmjej1740Cwk2fpvpA@mail.gmail.com>
References: <1309954239-17345-1-git-send-email-jlayton@redhat.com>
	<1309954239-17345-5-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309954239-17345-5-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/7/6 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Regression introduced in commit 724d9f1cfba.
>
> Prior to that, expand_dfs_referral would regenerate the mount data st=
ring
> and then call cifs_parse_mount_options to re-parse it (klunky, but it
> worked). The above commit moved cifs_parse_mount_options out of cifs_=
mount,
> so the re-parsing of the new mount options no longer occurred. Fix it=
 by
> making expand_dfs_referral re-parse the mount options.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 30 ++++++++++++++++++++----------
> =A01 files changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 46cc0ad..c254411 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -65,6 +65,8 @@ static int ip_connect(struct TCP_Server_Info *serve=
r);
> =A0static int generic_ip_connect(struct TCP_Server_Info *server);
> =A0static void tlink_rb_insert(struct rb_root *root, struct tcon_link=
 *new_tlink);
> =A0static void cifs_prune_tlinks(struct work_struct *work);
> +static int cifs_setup_volume_info(struct smb_vol *volume_info, char =
*mount_data,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 const char *devname);
>
> =A0/*
> =A0* cifs tcp session reconnection
> @@ -2830,12 +2832,9 @@ is_path_accessible(int xid, struct cifs_tcon *=
tcon,
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -void
> -cifs_cleanup_volume_info(struct smb_vol *volume_info)
> +static void
> +cleanup_volume_info_contents(struct smb_vol *volume_info)
> =A0{
> - =A0 =A0 =A0 if (!volume_info)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> -
> =A0 =A0 =A0 =A0kfree(volume_info->username);
> =A0 =A0 =A0 =A0kzfree(volume_info->password);
> =A0 =A0 =A0 =A0kfree(volume_info->UNC);
> @@ -2843,10 +2842,18 @@ cifs_cleanup_volume_info(struct smb_vol *volu=
me_info)
> =A0 =A0 =A0 =A0kfree(volume_info->domainname);
> =A0 =A0 =A0 =A0kfree(volume_info->iocharset);
> =A0 =A0 =A0 =A0kfree(volume_info->prepath);
> +}
> +
> +void
> +cifs_cleanup_volume_info(struct smb_vol *volume_info)
> +{
> + =A0 =A0 =A0 if (!volume_info)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 cleanup_volume_info_contents(volume_info);
> =A0 =A0 =A0 =A0kfree(volume_info);
> - =A0 =A0 =A0 return;
> =A0}
>
> +
> =A0#ifdef CONFIG_CIFS_DFS_UPCALL
> =A0/* build_path_to_root returns full path to root when
> =A0* we do not have an exiting connection (tcon) */
> @@ -2915,15 +2922,18 @@ expand_dfs_referral(int xid, struct cifs_ses =
*pSesInfo,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &fake_devname);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0free_dfs_info_array(referrals, num_ref=
errals);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(fake_devname);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mountdata !=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cifs_sb->mountdat=
a);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (IS_ERR(mdata)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D PTR_ERR(mdata);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mdata =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cleanup_volume_info_con=
tents(volume_info);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(volume_info, '\0=
', sizeof(*volume_info));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_setup_volum=
e_info(volume_info, mdata,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fake_devname);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(fake_devname);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cifs_sb->mountdata);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mountdata =3D mdata;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0kfree(full_path);
> --
> 1.7.6
>
>

Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
