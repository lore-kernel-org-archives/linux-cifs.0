From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Display strictcache mount option in /proc/mounts
Date: Wed, 19 Oct 2011 21:10:01 -0500
Message-ID: <CAH2r5msg+q2g9_iPnhEDbgxmROwVRid=XrkrCPELjH-8vYYbFg@mail.gmail.com>
References: <1318337032.3659.65.camel@sprabhu.fab.redhat.com>
	<CAH2r5ms0Udg87PTi9sRZsWbp3+SvCOKScHg3nWh6OtjKFNALqg@mail.gmail.com>
	<1318861755.30821.27.camel@sprabhu.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318861755.30821.27.camel-yuq4rhG59MBosH8Q1Ye95IGKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 17, 2011 at 9:29 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> On Tue, 2011-10-11 at 12:40 -0500, Steve French wrote:
>> Looks reasonable - are we missing any more from the list of mount
>> options that might matter to display?
>>
> When comparing the options parsed in cifs_parse_mount_options() and o=
nes
> shown in cifs_show_options(), there seems to be a few which are
> missing.
>
> A quick list made by comparing the options parsed and displayed..
> sign
> nostrictsync/strictsync
> noperm/perm
> iocharset
> locallease
> netbiosname
> noautotune
> noblocksnd
> nodfs
> port
> prefixpath
> sec
> servern
> sockopt
>
> Below is a simple patch which also includes the nostrictsync and nope=
rm
> mount options.
>
> Sachin Prabhu
> --
>
> Show nostrictsync and noperm mount options in /proc/mounts
>
> Add support to print nostrictsync and noperm mount options in /proc/m=
ounts for shares mounted with these options.
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c | =A0 =A04 ++++
> =A01 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 54b8f1e..eb6e8bf 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -432,6 +432,10 @@ cifs_show_options(struct seq_file *s, struct vfs=
mount *m)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",mfsymlinks");
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",fsc");
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",nostrictsync");
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",noperm");
>
> =A0 =A0 =A0 =A0seq_printf(s, ",rsize=3D%d", cifs_sb->rsize);
> =A0 =A0 =A0 =A0seq_printf(s, ",wsize=3D%d", cifs_sb->wsize);

I had to redo to avoid the merge conflict (your patch was not built on
the previous one so conflicted with it) - but now merged.


--=20
Thanks,

Steve
