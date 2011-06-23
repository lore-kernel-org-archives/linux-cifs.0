From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix wsize negotiation to respect max buffer size
 and active signing (try #4)
Date: Thu, 23 Jun 2011 12:54:48 -0500
Message-ID: <BANLkTin4oYFxEqGdEcQC7rmLQ=usNe0LEg@mail.gmail.com>
References: <1308778437-16794-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308778437-16794-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Wed, Jun 22, 2011 at 4:33 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Hopefully last version. Base signing check on CAP_UNIX instead of
> tcon->unix_ext, also clean up the comments a bit more.
>
> According to Hongwei Sun's blog posting here:
>
> =A0 =A0http://blogs.msdn.com/b/openspecification/archive/2009/04/10/s=
mb-maximum-transmit-buffer-size-and-performance-tuning.aspx
>
> CAP_LARGE_WRITEX is ignored when signing is active. Also, the maximum
> size for a write without CAP_LARGE_WRITEX should be the maxBuf that
> the server sent in the NEGOTIATE request.
>
> Fix the wsize negotiation to take this into account. While we're at i=
t,
> alter the other wsize definitions to use sizeof(WRITE_REQ) to allow f=
or
> slightly larger amounts of data to potentially be written per request=
=2E
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 33 ++++++++++++++++++++-------------
> =A01 files changed, 20 insertions(+), 13 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b15b5b0..c8cb83e 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2754,21 +2754,21 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolu=
me_info,
>
> =A0/*
> =A0* When the server supports very large writes via POSIX extensions,=
 we can
> - * allow up to 2^24 - PAGE_CACHE_SIZE.
> + * allow up to 2^24-1, minus the size of a WRITE_AND_X header, not i=
ncluding
> + * the RFC1001 length.
> =A0*
> =A0* Note that this might make for "interesting" allocation problems =
during
> - * writeback however (as we have to allocate an array of pointers fo=
r the
> - * pages). A 16M write means ~32kb page array with PAGE_CACHE_SIZE =3D=
=3D 4096.
> + * writeback however as we have to allocate an array of pointers for=
 the
> + * pages. A 16M write means ~32kb page array with PAGE_CACHE_SIZE =3D=
=3D 4096.
> =A0*/
> -#define CIFS_MAX_WSIZE ((1<<24) - PAGE_CACHE_SIZE)
> +#define CIFS_MAX_WSIZE ((1<<24) - 1 - sizeof(WRITE_REQ) + 4)
>
> =A0/*
> - * When the server doesn't allow large posix writes, default to a ws=
ize of
> - * 128k - PAGE_CACHE_SIZE -- one page less than the largest frame si=
ze
> - * described in RFC1001. This allows space for the header without go=
ing over
> - * that by default.
> + * When the server doesn't allow large posix writes, only allow a ws=
ize of
> + * 128k minus the size of the WRITE_AND_X header. That allows for a =
write up
> + * to the maximum size described by RFC1002.
> =A0*/
> -#define CIFS_MAX_RFC1001_WSIZE (128 * 1024 - PAGE_CACHE_SIZE)
> +#define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4)
>
> =A0/*
> =A0* The default wsize is 1M. find_get_pages seems to return a maximu=
m of 256
> @@ -2787,11 +2787,18 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, =
struct smb_vol *pvolume_info)
>
> =A0 =A0 =A0 =A0/* can server support 24-bit write sizes? (via UNIX ex=
tensions) */
> =A0 =A0 =A0 =A0if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WR=
ITE_CAP))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wsize =3D min_t(unsigned int, wsize, CI=
=46S_MAX_RFC1001_WSIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wsize =3D min_t(unsigned int, wsize, CI=
=46S_MAX_RFC1002_WSIZE);
>
> - =A0 =A0 =A0 /* no CAP_LARGE_WRITE_X? Limit it to 16 bits */
> - =A0 =A0 =A0 if (!(server->capabilities & CAP_LARGE_WRITE_X))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wsize =3D min_t(unsigned int, wsize, US=
HRT_MAX);
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* no CAP_LARGE_WRITE_X or is signing enabled without=
 CAP_UNIX set?
> + =A0 =A0 =A0 =A0* Limit it to max buffer offered by the server, minu=
s the size of the
> + =A0 =A0 =A0 =A0* WRITEX header, not including the 4 byte RFC1001 le=
ngth.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!(server->capabilities & CAP_LARGE_WRITE_X) ||
> + =A0 =A0 =A0 =A0 =A0 (!(server->capabilities & CAP_UNIX) &&
> + =A0 =A0 =A0 =A0 =A0 =A0(server->sec_mode & (SECMODE_SIGN_ENABLED|SE=
CMODE_SIGN_REQUIRED))))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wsize =3D min_t(unsigned int, wsize,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server-=
>maxBuf - sizeof(WRITE_REQ) + 4);
>
> =A0 =A0 =A0 =A0/* hard limit of CIFS_MAX_WSIZE */
> =A0 =A0 =A0 =A0wsize =3D min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
> --
> 1.7.5.4
>
>



--=20
Thanks,

Steve
