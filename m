From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: SMBD: fix configurations with INFINIBAND=m
Date: Tue, 19 Dec 2017 12:01:19 +0100
Message-ID: <4f2d6c8d-2958-3eb4-25b3-c789a0e1226d@samba.org>
References: <20171219101327.2165797-1-arnd@arndb.de>
 <77af1425-2d5a-8482-fa39-c83d2056eaa4@samba.org>
 <CAK8P3a3TQSt8skuyu7uHBbyG_jHS8wUaPPJ1XSh4u+aHxBzN8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="PdBlwWBa4dvV7QhU3i7paA2Ckrwg62avl"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
        Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAK8P3a3TQSt8skuyu7uHBbyG_jHS8wUaPPJ1XSh4u+aHxBzN8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PdBlwWBa4dvV7QhU3i7paA2Ckrwg62avl
Content-Type: multipart/mixed; boundary="777Nq7n9DWuBuCOHGhAWDDFHT7LxFSsr2";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
 Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Message-ID: <4f2d6c8d-2958-3eb4-25b3-c789a0e1226d-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: SMBD: fix configurations with INFINIBAND=m
References: <20171219101327.2165797-1-arnd-r2nGTMty4D4@public.gmane.org>
 <77af1425-2d5a-8482-fa39-c83d2056eaa4-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <CAK8P3a3TQSt8skuyu7uHBbyG_jHS8wUaPPJ1XSh4u+aHxBzN8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAK8P3a3TQSt8skuyu7uHBbyG_jHS8wUaPPJ1XSh4u+aHxBzN8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--777Nq7n9DWuBuCOHGhAWDDFHT7LxFSsr2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 19.12.2017 um 11:56 schrieb Arnd Bergmann via samba-technical:
> On Tue, Dec 19, 2017 at 11:33 AM, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> w=
rote:
>> Hi Arnd,
>>
>>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>>> index 500fd69fb58b..3bfc55c08bef 100644
>>> --- a/fs/cifs/Kconfig
>>> +++ b/fs/cifs/Kconfig
>>> @@ -199,6 +199,7 @@ config CIFS_SMB311
>>>  config CIFS_SMB_DIRECT
>>>       bool "SMB Direct support (Experimental)"
>>>       depends on CIFS && INFINIBAND
>>> +     depends on CIFS=3Dm || INFINIBAND=3Dy
>>>       help
>>>         Enables SMB Direct experimental support for SMB 3.0, 3.02 and=
 3.1.1.
>>>         SMB Direct allows transferring SMB packets over RDMA. If unsu=
re,
>>
>> Is this really correct? Should CIFS_SMB_DIRECT be allowed with:
>>
>> CIFS=3Dn and INFINIBAND=3Dy ???
>> or
>> CIFS=3Dm and INFINIBAND=3Dn ???
>>
>> I guess a more complex logic should be used here
>> or am I missing something?
>=20
> The two ones you listed are prohibited by the existing
> 'depends on CIFS && INFINIBAND' dependency.
>=20
> We could rephrase the dependency as
>=20
> depends on (CIFS=3Dy && INFINIBAND=3Dy) || \
>             (CIFS=3Dm && INFINIBAND=3Dy) || \
>             (CIFS=3Dm && INFINIBAND=3Dm)
>=20
> which has the same effect as
>=20
>       depends on CIFS && INFINIBAND
>       depends on CIFS=3Dm || INFINIBAND=3Dy
>=20
> but I don't think that adds any clarity.

Thanks for the clarification!

I somehow assumed the patch has been:


-      depends on CIFS && INFINIBAND
+      depends on CIFS=3Dm || INFINIBAND=3Dy

instead of:
       depends on CIFS && INFINIBAND
+      depends on CIFS=3Dm || INFINIBAND=3Dy

metze


--777Nq7n9DWuBuCOHGhAWDDFHT7LxFSsr2--

--PdBlwWBa4dvV7QhU3i7paA2Ckrwg62avl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJaOPGCAAoJEA219WEoab1WVDYP+gNY3tMdEwxyc/amO5Ca42si
oFDOQEbMfn7zw0lz2ecXOVFrvU3gCC237pwJ0EF949YSplWQiC2cCc8OjVu6GnYL
MKX4IoywkvsDOpneDT2b5mMVM3gOM8qTN7CWIjAoStk7P26bIypiSvaZigsCVO+7
dNyBYv54D2hzjAxbzVxACI/3JELyr3jRxrijKVIIRfSmQbtBYyFMwN6fSp3wtidn
Az99Fc2OB2381hqECSALkDea3mnVKuIzKa3uQk8WgYHnwk1rGQZOFn7unJ9EB/SS
1EmL8uAG8nQNm43uaYEXyZ6Vxoi5Rlu4f96if4Volll+raQgDsMTpe4Tjc4moHbI
3VjeuWr1iihGUCE6mg6GUwgMmeg+wZkDXttalxjmsDCgdRezJwMkNIYjiIsEHAmW
hIJk5S90Bqz0a/je9qUoQfMav1qgr0FSGg+J3laBRBXV6oWoubYfpo8nn690eBCL
LfvrzEEOZd2mWiMocxskDWi2JK7WfPCgXEnTm5pNJ5cZFwWFPPFv/U740ek4oUVn
ZpULuoFPS+twPotsURPFUYs6BQlqip+N1evZidAqdJ3cvd006ToomUb1CE45KxhZ
B2GptsjyCGB448w4lP7azLY5GAH0TH6GrUNPJPLYUJOjPzpJJMk+Gl+lkA+bNi6a
V/KlPdmMQzvEMpseRpTj
=1fBU
-----END PGP SIGNATURE-----

--PdBlwWBa4dvV7QhU3i7paA2Ckrwg62avl--
