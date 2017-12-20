From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: SMBD: fix configurations with INFINIBAND=m
Date: Wed, 20 Dec 2017 07:34:14 +0100
Message-ID: <0fbfe032-8c0e-8604-cdef-24d5a1a2d861@samba.org>
References: <20171219101327.2165797-1-arnd@arndb.de>
 <MWHPR21MB08468B3FE04EAF4B41A92B75CE0F0@MWHPR21MB0846.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="5uAdb4o11EYHoFwc8J0l0JT0IxpI4F1oK"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <MWHPR21MB08468B3FE04EAF4B41A92B75CE0F0-saRRjQKJ25OdAu0pOMKhMc1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5uAdb4o11EYHoFwc8J0l0JT0IxpI4F1oK
Content-Type: multipart/mixed; boundary="BwSBaGkp1A9FK9ZxuUCqBtWbPosrhbzG9";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>,
 Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
 Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>,
 "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <0fbfe032-8c0e-8604-cdef-24d5a1a2d861-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: SMBD: fix configurations with INFINIBAND=m
References: <20171219101327.2165797-1-arnd-r2nGTMty4D4@public.gmane.org>
 <MWHPR21MB08468B3FE04EAF4B41A92B75CE0F0-saRRjQKJ25OdAu0pOMKhMc1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
In-Reply-To: <MWHPR21MB08468B3FE04EAF4B41A92B75CE0F0-saRRjQKJ25OdAu0pOMKhMc1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>

--BwSBaGkp1A9FK9ZxuUCqBtWbPosrhbzG9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 19.12.2017 um 22:21 schrieb Long Li via samba-technical:
>>  	depends on CIFS && INFINIBAND
>> +	depends on CIFS=3Dm || INFINIBAND=3Dy
>=20
> How about we change them to
>=20
>         depends on CIFS=3Dm && INFINIBAND || CIFS=3Dy && INFINIBAND=3Dy=

>=20
> This makes it easy to read.

I like it :-)

metze



--BwSBaGkp1A9FK9ZxuUCqBtWbPosrhbzG9--

--5uAdb4o11EYHoFwc8J0l0JT0IxpI4F1oK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJaOgRpAAoJEA219WEoab1WUZAQAIHiACGRQiE18W4G8ydeL7rG
zy5mIywfjsvuy6EqCU3cKxmg+nIKJuHLFCRhH1mmKGCctngVfW6Ra+2QKE5plGCn
tyZaLU4+jjbWrOMJDajkI4DWdwm2+qXQOsnjUIHRbzn0o/kI6mAvbhSkB+lhpV9a
EuLzsfHwitBiwEyvWZCOXd4vzGNuSzRQ6YPU2spp95AGS6CX+X85vswUq+Axr5qE
XCQ1f0JXcYLptUJJWHPTTUKHRFH7bB83YPi8/DJiARCW2om3vzXHWHNZwpPqraJn
ckkMpXEqGYTnadc+V6O5oWHYBu9N8ym9kVLXuLXQZhW8jGwvlixSPUz3N8/GgyvO
DW6xegbsNOLIZwyLpHYe01YSUSlF1fLQJWcmS+6e4z6gx/2TMHvMrNCQE9i9VriZ
F+o9wWbahfAwYBJExSz82UW6j3mq0SwcLOLqDpLM2TOZebxa9uYl9wAxMwJyeHaP
JhHFaj1gWp377nRGnYquIN4GKsMBtB1s1KIAQO3tSw57zDggNuyZla5MrGNSYJA4
LQW1TqqjbCtKda7Y/6/XOHcRLlnABpzs9f2V/KL4rYrGNNf1e42QOAwn+5SmEwK1
QSh9zZcBLOeViF4QbS5vepFWlSzz01splA/V6qvTdL1YGZ1yw0eD3I6DGWq4n6cv
aCKrpDIJbAYIvfWTULMe
=IEuJ
-----END PGP SIGNATURE-----

--5uAdb4o11EYHoFwc8J0l0JT0IxpI4F1oK--
