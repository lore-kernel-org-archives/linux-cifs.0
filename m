From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: make CIFS depend on CRYPTO_MD4
Date: Mon, 31 Jan 2011 07:44:48 -0600
Message-ID: <AANLkTinFwzDjOhVv_dD1gFUhN+JftyH2rcJrqGJ2J82c@mail.gmail.com>
References: <4D469C99.9050905@suse.de>
	<1296481296-13270-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296481296-13270-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jan 31, 2011 at 7:41 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Recently CIFS was changed to use the kernel crypto API for MD4 hashes=
,
> but the Kconfig dependencies were not changed to reflect this.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reported-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
> =A0fs/cifs/Kconfig | =A0 =A01 +
> =A01 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 27917a5..023d11b 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -3,6 +3,7 @@ config CIFS
> =A0 =A0 =A0 =A0depends on INET
> =A0 =A0 =A0 =A0select NLS
> =A0 =A0 =A0 =A0select CRYPTO
> + =A0 =A0 =A0 select CRYPTO_MD4
> =A0 =A0 =A0 =A0select CRYPTO_MD5
> =A0 =A0 =A0 =A0select CRYPTO_HMAC
> =A0 =A0 =A0 =A0select CRYPTO_ARC4
> --
> 1.7.3.4
>
>

Thanks Jeff.  Missed to make this change in an earlier patch.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
