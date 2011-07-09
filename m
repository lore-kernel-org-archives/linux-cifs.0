From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: move bdi_setup_and_register outside of CONFIG_CIFS_DFS_UPCALL
Date: Sat, 9 Jul 2011 17:13:45 -0500
Message-ID: <CAH2r5mvoRmkhzQbB+Q1dM3wQQYy0jr1NJVr7bhs4e7qvw6zKMg@mail.gmail.com>
References: <1310228467-27466-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310228467-27466-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

looks correct; merged

On Sat, Jul 9, 2011 at 11:21 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> This needs to be done regardless of whether that KConfig option is se=
t
> or not.
>
> Reported-by: Sven-Haegar Koch <haegar-DcL44mDNY06zQB+pC5nmwQ@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A02 ++
> =A01 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index fea9ecf..dd695c5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3011,6 +3011,7 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct=
 smb_vol *volume_info)
> =A0 =A0 =A0 =A0struct tcon_link *tlink;
> =A0#ifdef CONFIG_CIFS_DFS_UPCALL
> =A0 =A0 =A0 =A0int referral_walks_count =3D 0;
> +#endif
>
> =A0 =A0 =A0 =A0rc =3D bdi_setup_and_register(&cifs_sb->bdi, "cifs", B=
DI_CAP_MAP_COPY);
> =A0 =A0 =A0 =A0if (rc)
> @@ -3018,6 +3019,7 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct=
 smb_vol *volume_info)
>
> =A0 =A0 =A0 =A0cifs_sb->bdi.ra_pages =3D default_backing_dev_info.ra_=
pages;
>
> +#ifdef CONFIG_CIFS_DFS_UPCALL
> =A0try_mount_again:
> =A0 =A0 =A0 =A0/* cleanup activities if we're chasing a referral */
> =A0 =A0 =A0 =A0if (referral_walks_count) {
> --
> 1.7.6
>
>



--=20
Thanks,

Steve
