From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 7/7] cifs: clean up wsize negotiation and allow for larger wsize
Date: Wed, 25 May 2011 14:46:38 +0400
Message-ID: <BANLkTinNOQoyhni4mrFRaMKRoOdf7WF6Dg@mail.gmail.com>
References: <1305836578-26333-1-git-send-email-jlayton@redhat.com>
	<1305836578-26333-8-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305836578-26333-8-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/20 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Now that we can handle larger wsizes in writepages, fix up the
> negotiation of the wsize to allow for that. find_get_pages only seems=
 to
> give out a max of 256 pages at a time, so that gives us a reasonable
> default of 1M for the wsize.
>
> If the server however does not support large writes via POSIX
> extensions, then we cap the wsize to (128k - PAGE_CACHE_SIZE). That
> gives us a size that goes up to the max frame size specified in RFC10=
01.
>
> Finally, if CAP_LARGE_WRITE_AND_X isn't set, then further cap it to t=
he
> largest size allowed by the protocol (USHRT_MAX).
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 69 +++++++++++++++++++++++++++++++++++++--=
-------------
> =A01 files changed, 49 insertions(+), 20 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ccb3ff8..490fb68 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2633,23 +2633,6 @@ static void setup_cifs_sb(struct smb_vol *pvol=
ume_info,
> =A0 =A0 =A0 =A0else /* default */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->rsize =3D CIFSMaxBufSize;
>
> - =A0 =A0 =A0 if (pvolume_info->wsize > PAGEVEC_SIZE * PAGE_CACHE_SIZ=
E) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "wsize %d too large, using 40=
96 instead",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pvolume_info->wsize=
);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->wsize =3D 4096;
> - =A0 =A0 =A0 } else if (pvolume_info->wsize)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->wsize =3D pvolume_info->wsize;
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->wsize =3D min_t(const int,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 PAGEVEC_SIZE * PAGE_CACHE_SIZE,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 127*1024);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* old default of CIFSMaxBufSize was to=
o small now
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that SMB Write2 can send multipl=
e pages in kvec.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0RFC1001 does not describe what h=
appens when frame
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bigger than 128K is sent so use =
that as max in
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0conjunction with 52K kvec constr=
aint on arch with 4K
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page size =A0*/
> -
> =A0 =A0 =A0 =A0if (cifs_sb->rsize < 2048) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->rsize =3D 2048;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Windows ME may prefer this */
> @@ -2727,6 +2710,53 @@ static void setup_cifs_sb(struct smb_vol *pvol=
ume_info,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "mount option sup=
ported");
> =A0}
>
> +/*
> + * When the server supports very large writes via POSIX extensions, =
we can
> + * allow up to 2^24 - PAGE_CACHE_SIZE.
> + *
> + * Note that this might make for "interesting" allocation problems d=
uring
> + * writeback however (as we have to allocate an array of pointers fo=
r the
> + * pages). A 16M write means ~32kb page array with PAGE_CACHE_SIZE =3D=
=3D 4096.
> + */
> +#define CIFS_MAX_WSIZE ((1<<24) - PAGE_CACHE_SIZE)
> +
> +/*
> + * When the server doesn't allow large posix writes, default to a ws=
ize of
> + * 128k - PAGE_CACHE_SIZE -- one page less than the largest frame si=
ze
> + * described in RFC1001. This allows space for the header without go=
ing over
> + * that by default.
> + */
> +#define CIFS_MAX_RFC1001_WSIZE (128 * 1024 - PAGE_CACHE_SIZE)
> +
> +/*
> + * The default wsize is 1M. find_get_pages seems to return a maximum=
 of 256
> + * pages in a single call. With PAGE_CACHE_SIZE =3D=3D 4k, this mean=
s we can fill
> + * a single wsize request with a single call.
> + */
> +#define CIFS_DEFAULT_WSIZE (1024 * 1024)
> +
> +static unsigned int
> +cifs_negotiate_wsize(struct cifsTconInfo *tcon, struct smb_vol *pvol=
ume_info)
> +{
> + =A0 =A0 =A0 __u64 unix_cap =3D le64_to_cpu(tcon->fsUnixInfo.Capabil=
ity);
> + =A0 =A0 =A0 struct TCP_Server_Info *server =3D tcon->ses->server;
> + =A0 =A0 =A0 unsigned int wsize =3D pvolume_info->wsize ? pvolume_in=
fo->wsize :
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_DE=
=46AULT_WSIZE;
> +
> + =A0 =A0 =A0 /* can server support 24-bit write sizes? (via UNIX ext=
ensions) */
> + =A0 =A0 =A0 if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRI=
TE_CAP))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wsize =3D min_t(unsigned int, wsize, CI=
=46S_MAX_RFC1001_WSIZE);
> +
> + =A0 =A0 =A0 /* no CAP_LARGE_WRITE_X? Limit it to 16 bits */
> + =A0 =A0 =A0 if (!(server->capabilities & CAP_LARGE_WRITE_X))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wsize =3D min_t(unsigned int, wsize, US=
HRT_MAX);
> +
> + =A0 =A0 =A0 /* hard limit of CIFS_MAX_WSIZE */
> + =A0 =A0 =A0 wsize =3D min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
> +
> + =A0 =A0 =A0 return wsize;
> +}
> +
> =A0static int
> =A0is_path_accessible(int xid, struct cifsTconInfo *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sb_info *cifs_sb, con=
st char *full_path)
> @@ -2988,13 +3018,12 @@ try_mount_again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->rsize =3D 1024 * 127;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(DBG2, "no very large read support=
, rsize now 127K");
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 if (!(tcon->ses->capabilities & CAP_LARGE_WRITE_X))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->wsize =3D min(cifs_sb->wsize,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(tcon->s=
es->server->maxBuf - MAX_CIFS_HDR_SIZE));
> =A0 =A0 =A0 =A0if (!(tcon->ses->capabilities & CAP_LARGE_READ_X))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->rsize =3D min(cifs_sb->rsize,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (tcon->se=
s->server->maxBuf - MAX_CIFS_HDR_SIZE));
>
> + =A0 =A0 =A0 cifs_sb->wsize =3D cifs_negotiate_wsize(tcon, volume_in=
fo);
> +
> =A0remote_path_check:
> =A0#ifdef CONFIG_CIFS_DFS_UPCALL
> =A0 =A0 =A0 =A0/*
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Reviewed-and-Tested-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
