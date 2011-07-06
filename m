From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] cifs: fix build_unc_path_to_root to account for a prefixpath
Date: Wed, 6 Jul 2011 18:12:55 +0400
Message-ID: <CAKywueT143gbpfnfmF3OP+MwC7THYt1homKtQsXKVZGBqe8ZBA@mail.gmail.com>
References: <1309954239-17345-1-git-send-email-jlayton@redhat.com>
	<1309954239-17345-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309954239-17345-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/7/6 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Regression introduced by commit f87d39d9513.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 21 +++++++++++++++------
> =A01 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 545e854..44376ce 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2855,19 +2855,28 @@ cifs_cleanup_volume_info(struct smb_vol **pvo=
lume_info)
> =A0/* build_path_to_root returns full path to root when
> =A0* we do not have an exiting connection (tcon) */
> =A0static char *
> -build_unc_path_to_root(const struct smb_vol *volume_info,
> +build_unc_path_to_root(const struct smb_vol *vol,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct cifs_sb_info *cifs_sb)
> =A0{
> - =A0 =A0 =A0 char *full_path;
> + =A0 =A0 =A0 char *full_path, *pos;
> + =A0 =A0 =A0 unsigned int pplen =3D vol->prepath ? strlen(vol->prepa=
th) : 0;
> + =A0 =A0 =A0 unsigned int unc_len =3D strnlen(vol->UNC, MAX_TREE_SIZ=
E + 1);
>
> - =A0 =A0 =A0 int unc_len =3D strnlen(volume_info->UNC, MAX_TREE_SIZE=
 + 1);
> - =A0 =A0 =A0 full_path =3D kmalloc(unc_len + 1, GFP_KERNEL);
> + =A0 =A0 =A0 full_path =3D kmalloc(unc_len + pplen + 1, GFP_KERNEL);
> =A0 =A0 =A0 =A0if (full_path =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ERR_PTR(-ENOMEM);
>
> - =A0 =A0 =A0 strncpy(full_path, volume_info->UNC, unc_len);
> - =A0 =A0 =A0 full_path[unc_len] =3D 0; /* add trailing null */
> + =A0 =A0 =A0 strncpy(full_path, vol->UNC, unc_len);
> + =A0 =A0 =A0 pos =3D full_path + unc_len;
> +
> + =A0 =A0 =A0 if (pplen) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncpy(pos, vol->prepath, pplen);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pos +=3D pplen;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 *pos =3D '\0'; /* add trailing null */
> =A0 =A0 =A0 =A0convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
> + =A0 =A0 =A0 cFYI(1, "%s: full_path=3D%s", __func__, full_path);
> =A0 =A0 =A0 =A0return full_path;
> =A0}
>
> --
> 1.7.6
>
>

Ops, I missed it, thanks!

Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
