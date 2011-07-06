From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/4] cifs: factor smb_vol allocation out of cifs_setup_volume_info
Date: Wed, 6 Jul 2011 18:13:41 +0400
Message-ID: <CAKywueTqyq0GtdFu1t03EOdBQzA-Jm9xEtO81p797eoRHq_0tA@mail.gmail.com>
References: <1309954239-17345-1-git-send-email-jlayton@redhat.com>
	<1309954239-17345-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309954239-17345-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/7/6 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 =A06 ++--
> =A0fs/cifs/cifsproto.h | =A0 =A04 +-
> =A0fs/cifs/connect.c =A0 | =A0 56 +++++++++++++++++++++++++----------=
---------------
> =A03 files changed, 33 insertions(+), 33 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index e11b831..3e29899 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -649,9 +649,9 @@ cifs_do_mount(struct file_system_type *fs_type,
>
> =A0 =A0 =A0 =A0cFYI(1, "Devname: %s flags: %d ", dev_name, flags);
>
> - =A0 =A0 =A0 rc =3D cifs_setup_volume_info(&volume_info, (char *)dat=
a, dev_name);
> - =A0 =A0 =A0 if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(rc);
> + =A0 =A0 =A0 volume_info =3D cifs_get_volume_info((char *)data, dev_=
name);
> + =A0 =A0 =A0 if (IS_ERR(volume_info))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_CAST(volume_info);
>
> =A0 =A0 =A0 =A0cifs_sb =3D kzalloc(sizeof(struct cifs_sb_info), GFP_K=
ERNEL);
> =A0 =A0 =A0 =A0if (cifs_sb =3D=3D NULL) {
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 53b1b13..8df28e9 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -155,8 +155,8 @@ extern void cifs_setup_cifs_sb(struct smb_vol *pv=
olume_info,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ci=
fs_sb_info *cifs_sb);
> =A0extern int cifs_match_super(struct super_block *, void *);
> =A0extern void cifs_cleanup_volume_info(struct smb_vol *pvolume_info)=
;
> -extern int cifs_setup_volume_info(struct smb_vol **pvolume_info,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cha=
r *mount_data, const char *devname);
> +extern struct smb_vol *cifs_get_volume_info(char *mount_data,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 const char *devname);
> =A0extern int cifs_mount(struct cifs_sb_info *, struct smb_vol *);
> =A0extern void cifs_umount(struct cifs_sb_info *);
> =A0extern void cifs_dfs_release_automount_timer(void);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index dd06407..46cc0ad 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2931,33 +2931,20 @@ expand_dfs_referral(int xid, struct cifs_ses =
*pSesInfo,
> =A0}
> =A0#endif
>
> -int cifs_setup_volume_info(struct smb_vol **pvolume_info, char *moun=
t_data,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *devn=
ame)
> +static int
> +cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *devname)
> =A0{
> - =A0 =A0 =A0 struct smb_vol *volume_info;
> =A0 =A0 =A0 =A0int rc =3D 0;
>
> - =A0 =A0 =A0 *pvolume_info =3D NULL;
> -
> - =A0 =A0 =A0 volume_info =3D kzalloc(sizeof(struct smb_vol), GFP_KER=
NEL);
> - =A0 =A0 =A0 if (!volume_info) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 if (cifs_parse_mount_options(mount_data, devname,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0volume_info)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (cifs_parse_mount_options(mount_data, devname, volum=
e_info))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>
> =A0 =A0 =A0 =A0if (volume_info->nullauth) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "null user");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0volume_info->username =3D kzalloc(1, G=
=46P_KERNEL);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (volume_info->username =3D=3D NULL) =
{
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (volume_info->username =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> =A0 =A0 =A0 =A0} else if (volume_info->username) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB fixme parse for domain name here=
 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Username: %s", volume_info->u=
sername);
> @@ -2965,8 +2952,7 @@ int cifs_setup_volume_info(struct smb_vol **pvo=
lume_info, char *mount_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifserror("No username specified");
> =A0 =A0 =A0 =A0/* In userspace mount helper we can get user name from=
 alternate
> =A0 =A0 =A0 =A0 =A0 locations such as env variables and files on disk=
 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* this is needed for ASCII cp to Unicode converts */
> @@ -2978,18 +2964,32 @@ int cifs_setup_volume_info(struct smb_vol **p=
volume_info, char *mount_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (volume_info->local_nls =3D=3D NULL=
) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "CIFS mount =
error: iocharset %s not found",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 volum=
e_info->iocharset);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ELIBACC;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ELIBACC;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 *pvolume_info =3D volume_info;
> - =A0 =A0 =A0 return rc;
> -out:
> - =A0 =A0 =A0 cifs_cleanup_volume_info(volume_info);
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +struct smb_vol *
> +cifs_get_volume_info(char *mount_data, const char *devname)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 struct smb_vol *volume_info;
> +
> + =A0 =A0 =A0 volume_info =3D kzalloc(sizeof(struct smb_vol), GFP_KER=
NEL);
> + =A0 =A0 =A0 if (!volume_info)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-ENOMEM);
> +
> + =A0 =A0 =A0 rc =3D cifs_setup_volume_info(volume_info, mount_data, =
devname);
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_cleanup_volume_info(volume_info);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 volume_info =3D ERR_PTR(rc);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return volume_info;
> +}
> +
> =A0int
> =A0cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_in=
fo)
> =A0{
> --
> 1.7.6
>
>

Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
