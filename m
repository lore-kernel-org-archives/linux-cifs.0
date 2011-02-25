From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 17/21]fs:cifs:connect.c remove one to many l's in the word.
Date: Fri, 25 Feb 2011 12:19:11 -0600
Message-ID: <AANLkTimneD0d=qpTq2CMpfvjYuQC2kx1mf2ZnORG32KK@mail.gmail.com>
References: <1298614502-4114-1-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298614502-4114-1-git-send-email-justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Fri, Feb 25, 2011 at 12:15 AM, Justin P. Mattock
<justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> The patch below removes an extra "l" in the word.
>
> Signed-off-by: Justin P. Mattock <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> ---
> =A0fs/cifs/connect.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8d6c17a..ea4a146 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -722,7 +722,7 @@ multi_t2_fnd:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sock_release(csocket);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->ssocket =3D NULL;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 /* buffer usuallly freed in free_mid - need to free it =
here on exit */
> + =A0 =A0 =A0 /* buffer usually freed in free_mid - need to free it h=
ere on exit */
> =A0 =A0 =A0 =A0cifs_buf_release(bigbuf);
> =A0 =A0 =A0 =A0if (smallbuf) /* no sense logging a debug message if N=
ULL */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_small_buf_release(smallbuf);
> --
> 1.7.4.1
>
>



--=20
Thanks,

Steve
