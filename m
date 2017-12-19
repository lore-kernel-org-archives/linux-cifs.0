From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: SMBD: fix configurations with INFINIBAND=m
Date: Tue, 19 Dec 2017 11:33:15 +0100
Message-ID: <77af1425-2d5a-8482-fa39-c83d2056eaa4@samba.org>
References: <20171219101327.2165797-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="uBxkqfia3vOjSQ0Fbb4tuuRBCj96OsrJD"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219101327.2165797-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uBxkqfia3vOjSQ0Fbb4tuuRBCj96OsrJD
Content-Type: multipart/mixed; boundary="N8PxT8IdT7IHhkS8xWlEI4hSm87OPDl4g";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Message-ID: <77af1425-2d5a-8482-fa39-c83d2056eaa4-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: SMBD: fix configurations with INFINIBAND=m
References: <20171219101327.2165797-1-arnd-r2nGTMty4D4@public.gmane.org>
In-Reply-To: <20171219101327.2165797-1-arnd-r2nGTMty4D4@public.gmane.org>

--N8PxT8IdT7IHhkS8xWlEI4hSm87OPDl4g
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 500fd69fb58b..3bfc55c08bef 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -199,6 +199,7 @@ config CIFS_SMB311
>  config CIFS_SMB_DIRECT
>  	bool "SMB Direct support (Experimental)"
>  	depends on CIFS && INFINIBAND
> +	depends on CIFS=3Dm || INFINIBAND=3Dy
>  	help
>  	  Enables SMB Direct experimental support for SMB 3.0, 3.02 and 3.1.1=
=2E
>  	  SMB Direct allows transferring SMB packets over RDMA. If unsure,

Is this really correct? Should CIFS_SMB_DIRECT be allowed with:

CIFS=3Dn and INFINIBAND=3Dy ???
or
CIFS=3Dm and INFINIBAND=3Dn ???

I guess a more complex logic should be used here
or am I missing something?

metze



--N8PxT8IdT7IHhkS8xWlEI4hSm87OPDl4g--

--uBxkqfia3vOjSQ0Fbb4tuuRBCj96OsrJD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJaOOruAAoJEA219WEoab1WbKoP/2uVjTaKRlY7dwwb2TBTH0uR
qVvQ9fhyrHsuC/9ftshZibmxLQ3orKTF1N6s5d0sPg9cj0vZlSNuzg9Z356DCkUy
k9+FigMAAe1n/yt5BNfV56ss8xDuroW7AtoEq9E26n6w4w0wGN8WzdSO6gp5KslW
Xs71OJS7dU5Obkxi3M6Oc0rvYBEoxz0EeknHAmcr0JHWRZEAVTTR7g5SDFSqPlzk
TMYYXH77qoTbk4+2+8i1CKsXw/L/Hifbttk1QPZm0W8FZ0dmXnGSN4udhAgSkPfe
g5KVle29JnHTHOYk18ct6k4nZh3p6ZmsZz199Bal55HlELNIWuRYSYoyB6F/7GV/
6YzEEoGzMRekXqYiQWo1YZAvv7aI+dg8OUOoW/kFH5ilZ4b7kIXcfDGi1b1ysDwr
yj3wAwcLmAbBeq2e82bNRGvFPFGqCue/CkTXmZdRERpeSvl32iJVqRWR+8iF4JFp
MtItWltJ98fK21S/XPtlg+r+QoYnjuAF8FjRveJXAR/V83gp+rzLzr3CyihTe6H3
oVRyrOtlo4BX2r7sonS9fADA/cgI/v1Twopu8WvgtNivGHFB4oFZZJHOULHvW6iw
9FUSZohFeqe50Jv0h4/cCagT5ziadPa4BeqEodSfprdJWa8OV3vuHsiCpDTM1ZFu
0546vGJiDwx6LbNNfk9F
=IA+/
-----END PGP SIGNATURE-----

--uBxkqfia3vOjSQ0Fbb4tuuRBCj96OsrJD--
