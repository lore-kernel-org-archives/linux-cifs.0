From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: advertise the right receive buffer size to the server
Date: Tue, 21 Jun 2011 09:03:05 -0500
Message-ID: <BANLkTim+LC=6GD2+0k1Fem9b1KLaNzof=A@mail.gmail.com>
References: <1308658004-14725-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308658004-14725-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

makes sense although I think some servers ignore this.

On Tue, Jun 21, 2011 at 7:06 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Currently, we mirror the same size back to the server that it sends u=
s.
> That makes little sense. Instead we should be sending the server the
> maximum buffer size that we can handle.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/sess.c | =A0 =A03 ++-
> =A01 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 3892ab8..855c777 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -124,7 +124,8 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *ses=
, SESSION_SETUP_ANDX *pSMB)
> =A0 =A0 =A0 =A0/* =A0 =A0 =A0that we use in next few lines =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0/* Note that header is initialized to zero in header_a=
ssemble */
> =A0 =A0 =A0 =A0pSMB->req.AndXCommand =3D 0xFF;
> - =A0 =A0 =A0 pSMB->req.MaxBufferSize =3D cpu_to_le16(ses->server->ma=
xBuf);
> + =A0 =A0 =A0 pSMB->req.MaxBufferSize =3D cpu_to_le16(min_t(u32, CIFS=
MaxBufSize,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 USHRT_MAX));
> =A0 =A0 =A0 =A0pSMB->req.MaxMpxCount =3D cpu_to_le16(ses->server->max=
Req);
> =A0 =A0 =A0 =A0pSMB->req.VcNumber =3D get_next_vcnum(ses);
>
> --
> 1.7.5.4
>
>



--=20
Thanks,

Steve
