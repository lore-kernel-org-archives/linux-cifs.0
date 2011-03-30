From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Use kstrdup instead of manual string duplication for cifs_sb->mountdata
Date: Wed, 30 Mar 2011 09:32:59 -0500
Message-ID: <AANLkTikLfYAB_bon0EGMUxgNADHZhoy4cZ0Pg6NUNqKV@mail.gmail.com>
References: <54430755071bdb37fe46abf3fda855bf35aaf891.1301492728.git.seanius@seanius.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54430755071bdb37fe46abf3fda855bf35aaf891.1301492728.git.seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks fine.

On Wed, Mar 30, 2011 at 8:07 AM, Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org> wrot=
e:
>
> A relatively minor nit, but also clarified the "consensus" from the
> preceding comments that it is in fact better to try for the kstrdup
> early and cleanup while cleaning up is still a simple thing to do.
>
> Signed-off-by: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c | =A0 17 ++++++-----------
> =A01 files changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index fb6a2ad..e938bf0 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -134,24 +134,19 @@ cifs_read_super(struct super_block *sb, void *d=
ata,
> =A0 =A0 =A0 =A0cifs_sb->bdi.ra_pages =3D default_backing_dev_info.ra_=
pages;
>
> =A0#ifdef CONFIG_CIFS_DFS_UPCALL
> - =A0 =A0 =A0 /* copy mount params to sb for use in submounts */
> - =A0 =A0 =A0 /* BB: should we move this after the mount so we
> - =A0 =A0 =A0 =A0* do not have to do the copy on failed mounts?
> - =A0 =A0 =A0 =A0* BB: May be it is better to do simple copy before
> - =A0 =A0 =A0 =A0* complex operation (mount), and in case of fail
> - =A0 =A0 =A0 =A0* just exit instead of doing mount and attempting
> - =A0 =A0 =A0 =A0* undo it if this copy fails?*/
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Copy mount params to sb for use in submounts. Bett=
er to do
> + =A0 =A0 =A0 =A0* the copy here and deal with the error before clean=
up gets
> + =A0 =A0 =A0 =A0* complicated post-mount.
> + =A0 =A0 =A0 =A0*/
> =A0 =A0 =A0 =A0if (data) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 int len =3D strlen(data);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mountdata =3D kzalloc(len + 1,=
 GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mountdata =3D kstrdup(data, GF=
P_KERNEL);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifs_sb->mountdata =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bdi_destroy(&cifs_sb->=
bdi);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(sb->s_fs_info);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_fs_info =3D NULL=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncpy(cifs_sb->mountdata, data, len +=
 1);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mountdata[len] =3D '\0';
> =A0 =A0 =A0 =A0}
> =A0#endif
>
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
Thanks,

Steve
