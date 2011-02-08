From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: reacquire CAP_DAC_READ_SEARCH before calling mount(2)
Date: Tue, 8 Feb 2011 14:25:16 -0600
Message-ID: <AANLkTi=cH2bHAiL2mNUQ=G9cuYtiVO4TuYOO4GbG34Oq@mail.gmail.com>
References: <1297195344-4460-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erik-nLcryBYLV+bMkAkIaI5Geg@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297195344-4460-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

On Tue, Feb 8, 2011 at 2:02 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> It's possible that the user is trying to mount onto a directory to wh=
ich
> he doesn't have execute perms. If that's the case then the mount will
> currently fail. Fix this by reenabling CAP_DAC_READ_SEARCH before
> calling mount(2). That will ensure that the kernel's permissions chec=
k
> for this is bypassed.
>
> Reported-by: Erik Logtenberg <erik-nLcryBYLV+bMkAkIaI5Geg@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0mount.cifs.c | =A0 10 ++++++++--
> =A01 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 3a2b539..8e1e32b 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1898,8 +1898,13 @@ mount_retry:
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fstype =3D cifs_fstype;
>
> - =A0 =A0 =A0 if (!parsed_info->fakemnt
> - =A0 =A0 =A0 =A0 =A0 && mount(dev_name, ".", fstype, parsed_info->fl=
ags, options)) {
> + =A0 =A0 =A0 if (!parsed_info->fakemnt) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 toggle_dac_capability(0, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D mount(dev_name, ".", fstype, par=
sed_info->flags, options);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 toggle_dac_capability(0, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto do_mtab;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (errno) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case ECONNREFUSED:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case EHOSTUNREACH:
> @@ -1934,6 +1939,7 @@ mount_retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto mount_exit;
> =A0 =A0 =A0 =A0}
>
> +do_mtab:
> =A0 =A0 =A0 =A0if (!parsed_info->nomtab && !mtab_unusable())
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D add_mtab(orig_dev, mountpoint, =
parsed_info->flags, fstype);
>
> --
> 1.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
