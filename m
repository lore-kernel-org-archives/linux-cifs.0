From: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cifs-utils PATCH] manpage: update mount.cifs manpage with info
 about default version being mounted
Date: Mon, 30 Oct 2017 18:13:17 +1000
Message-ID: <CAN05THR7gLxJBA285iRL6Exq=NZPvKnB3r0ocbjUoObFEVt2EA@mail.gmail.com>
References: <20171029105809.8954-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171029105809.8954-1-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


On Sun, Oct 29, 2017 at 8:58 PM, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.rst | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index 9714f795fe76..e70bf36fa32e 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -517,7 +517,7 @@ prefixpath=arg
>  vers=arg
>    SMB protocol version. Allowed values are:
>
> -  - 1.0 - The classic CIFS/SMBv1 protocol. This is the default.
> +  - 1.0 - The classic CIFS/SMBv1 protocol.
>    - 2.0 - The SMBv2.002 protocol. This was initially introduced in
>      Windows Vista Service Pack 1, and Windows Server 2008. Note that
>      the initial release version of Windows Vista spoke a slightly
> @@ -529,6 +529,9 @@ vers=arg
>    Note too that while this option governs the protocol version used, not
>    all features of each version are available.
>
> +  In kernels v4.13 and later, the default is ``3.0``. In kernels prior to
> +  v4.13, the default is ``1.0``.
> +
>  --verbose
>    Print additional debugging information for the mount. Note that this
>    parameter must be specified before the ``-o`` . For example::
> @@ -857,4 +860,3 @@ Steve French
>  The maintainer of the Linux cifs vfs and the userspace tool mount.cifs
>  is Steve French. The Linux CIFS Mailing list is the preferred place to
>  ask questions regarding these programs.
> -
> \ No newline at end of file
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
