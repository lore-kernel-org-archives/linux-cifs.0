From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fsc should not default to "on"
Date: Mon, 26 Jul 2010 13:50:15 -0500
Message-ID: <AANLkTikuksd14OARfqgkCXzh+TqO=VnV=Y-6uf3A9oDU@mail.gmail.com>
References: <1280168708-2943-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280168708-2943-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

agreed - merged

On Mon, Jul 26, 2010 at 1:25 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> I'm not sure why this was merged with this flag hardcoded on, but it
> seems quite dangerous. Turn it off.
>
> Also, mount.cifs hands unrecognized options off to the kernel so ther=
e
> should be no need for changes there in order to support this.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A03 ---
> =A01 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 85a994c..2a43a0a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -846,9 +846,6 @@ cifs_parse_mount_options(char *options, const cha=
r *devname,
> =A0 =A0 =A0 =A0/* default to using server inode numbers where availab=
le */
> =A0 =A0 =A0 =A0vol->server_ino =3D 1;
>
> - =A0 =A0 =A0 /* XXX: default to fsc for testing until mount.cifs pie=
ces are done */
> - =A0 =A0 =A0 vol->fsc =3D 1;
> -
> =A0 =A0 =A0 =A0if (!options)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
>
> --
> 1.7.1.1
>
>



--=20
Thanks,

Steve
