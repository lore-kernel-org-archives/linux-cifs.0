From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] fs/cifs/Kconfig: CIFS depends on CRYPTO_HMAC
Date: Sat, 13 Nov 2010 21:37:17 -0600
Message-ID: <AANLkTi=TW+3325Q8PBQ3ZNMDG6te7TXF09_S3heJe_8P@mail.gmail.com>
References: <4CDEF060.2050000@nctritech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jody Bruchon <jody-CwlhuK3P8e+1Z/+hSey0Gg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CDEF060.2050000-CwlhuK3P8e+1Z/+hSey0Gg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged the equivalent of this - thx.

On Sat, Nov 13, 2010 at 2:09 PM, Jody Bruchon <jody-CwlhuK3P8e+1Z/+hSey0Gg@public.gmane.org> wrot=
e:
> =A0I sent this patch in to LKML, but later realized it should probabl=
y go
> here. =A0I don't subscribe to the list, so please CC me directly with=
 any
> replies. =A0Thanks!
>
> Jody Bruchon
>
> -------- Original Message --------
> Subject: =A0 =A0 =A0 =A0[PATCH] fs/cifs/Kconfig: CIFS depends on CRYP=
TO_HMAC
> Date: =A0 Fri, 12 Nov 2010 13:41:06 -0500
> From: =A0 Jody Bruchon <jody-CwlhuK3P8e+1Z/+hSey0Gg@public.gmane.org>
> To: =A0 =A0 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
>
> linux-2.6.37-rc1: I compiled a kernel with CIFS which subsequently
> failed with an error indicating it couldn't initialize crypto module
> "hmacmd5". =A0CONFIG_CRYPTO_HMAC=3Dy fixed the problem.
>
> This patch makes CIFS depend on CRYPTO_HMAC in kconfig.
>
> Signed-off-by: Jody Bruchon<jody-CwlhuK3P8e+1Z/+hSey0Gg@public.gmane.org>
> ---
>
> diff -Naur linux-2.6.37-rc1/fs/cifs/Kconfig b/fs/cifs/Kconfig
> --- linux-2.6.37-rc1/fs/cifs/Kconfig =A0 =A02010-11-12 13:22:31.74299=
9981 -0500
> +++ b/fs/cifs/Kconfig =A0 =A02010-11-12 13:22:27.528998658 -0500
> @@ -4,6 +4,7 @@
> =A0 =A0 select NLS
> =A0 =A0 select CRYPTO
> =A0 =A0 select CRYPTO_MD5
> + =A0 =A0select CRYPTO_HMAC
> =A0 =A0 select CRYPTO_ARC4
> =A0 =A0 help
> =A0 =A0 =A0 This is the client VFS module for the Common Internet Fil=
e System
>
>
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
