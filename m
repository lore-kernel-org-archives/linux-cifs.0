From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Display strictcache mount option in /proc/mounts
Date: Tue, 11 Oct 2011 12:40:19 -0500
Message-ID: <CAH2r5ms0Udg87PTi9sRZsWbp3+SvCOKScHg3nWh6OtjKFNALqg@mail.gmail.com>
References: <1318337032.3659.65.camel@sprabhu.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318337032.3659.65.camel-yuq4rhG59MBosH8Q1Ye95IGKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks reasonable - are we missing any more from the list of mount
options that might matter to display?

On Tue, Oct 11, 2011 at 7:43 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> Commit d39454ffe4a3c85428483b8a8a8e5e797b6363d5 adds a strictcache mo=
unt
> option. This patch allows the display of this mount option in
> /proc/mounts when listing shares mounted with the strictcache mount
> option.
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 54b8f1e..03d2f6b 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -432,6 +432,8 @@ cifs_show_options(struct seq_file *s, struct vfsm=
ount *m)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",mfsymlinks");
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",fsc");
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",strictcache");
>
> =A0 =A0 =A0 =A0seq_printf(s, ",rsize=3D%d", cifs_sb->rsize);
> =A0 =A0 =A0 =A0seq_printf(s, ",wsize=3D%d", cifs_sb->wsize);
>
>
>



--=20
Thanks,

Steve
