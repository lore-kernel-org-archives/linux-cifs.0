From: Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH] fs/cifs: require sha512
Date: Mon, 10 Sep 2018 10:32:35 +0200
Message-ID: <9847cfe5-a5fa-7719-0d47-b5fc7c7b9423@samba.org>
References: <20180907162417.31977-1-metze@samba.org>
 <CAH2r5muE1e6L3hNQ4CWVjgO1RiaSEqTqO8LOf6R61jqKqT8YWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="SnjIlKm7PS9z2fBUscfznnE0sCGWcQo2C"
Cc: Steve French <stfrench@microsoft.com>,
        Stable <stable@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAH2r5muE1e6L3hNQ4CWVjgO1RiaSEqTqO8LOf6R61jqKqT8YWw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SnjIlKm7PS9z2fBUscfznnE0sCGWcQo2C
Content-Type: multipart/mixed; boundary="qaZYFDZtr1pUuINcUdO8vekBR3WXQnG4C";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <stfrench@microsoft.com>, Stable <stable@vger.kernel.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <9847cfe5-a5fa-7719-0d47-b5fc7c7b9423@samba.org>
Subject: Re: [PATCH] fs/cifs: require sha512
References: <20180907162417.31977-1-metze@samba.org>
 <CAH2r5muE1e6L3hNQ4CWVjgO1RiaSEqTqO8LOf6R61jqKqT8YWw@mail.gmail.com>
In-Reply-To: <CAH2r5muE1e6L3hNQ4CWVjgO1RiaSEqTqO8LOf6R61jqKqT8YWw@mail.gmail.com>

--qaZYFDZtr1pUuINcUdO8vekBR3WXQnG4C
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 09.09.2018 um 07:05 schrieb Steve French:
> merged into cifs-2.6-git for-next

Is this for 4.19? It's needed at least there, ( or into all places
where 0fdfef9aa7ee68ddd is included.

metze

> On Fri, Sep 7, 2018 at 11:25 AM Stefan Metzmacher <metze@samba.org> wro=
te:
>>
>> This got lost in commit 0fdfef9aa7ee68ddd508aef7c98630cfc054f8d6,
>> which removed CONFIG_CIFS_SMB311.
>>
>> Signed-off-by: Stefan Metzmacher <metze@samba.org>
>> Fixes: 0fdfef9aa7ee68ddd ("smb3: simplify code by removing CONFIG_CIFS=
_SMB311")
>> CC: Stable <stable@vger.kernel.org>
>> CC: linux-cifs@vger.kernel.org
>> ---
>>  fs/cifs/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>> index 35c83fe7dba01..abcd78e332feb 100644
>> --- a/fs/cifs/Kconfig
>> +++ b/fs/cifs/Kconfig
>> @@ -6,6 +6,7 @@ config CIFS
>>         select CRYPTO_MD4
>>         select CRYPTO_MD5
>>         select CRYPTO_SHA256
>> +       select CRYPTO_SHA512
>>         select CRYPTO_CMAC
>>         select CRYPTO_HMAC
>>         select CRYPTO_ARC4
>> --
>> 2.17.1
>>
>=20
>=20



--qaZYFDZtr1pUuINcUdO8vekBR3WXQnG4C--

--SnjIlKm7PS9z2fBUscfznnE0sCGWcQo2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAluWLCQACgkQDbX1YShp
vVa7LQ/9ErUgaPDWNBywoSn9n8G+oSiCPC7ed4lTNgPAp6m/xXdvuZIR9ghrZjgo
PSFOVaN6qXGdTxH+29i2CbmtgLhaZxUIkJ7uttdNeNDmybaeDI8lsDOh5NhgrBpc
EJFhF89R0QQNRLX7e4z2nW/+XMolboYbbxPoEQUcofgmsI1WKbXESH9t3H5+yWPr
3qofJLYSN1wlgLlUOHTFen4kZZ65IssF6cf/7UlQ++XcxjHWWCUuuUmrWnCEAfIV
xwpXpHoO16+hekgoUAul5awaFrPmsjbylaegwJ0pUuPh+n0fbDht0yRtFpesdU09
maiQedB4GLB07P/HTI9LyFZ7s8rDTDTBbLjr1EwffqPcJJVmG6vecUaaaArpeyY2
9blNAltCJhcp9VEKaDaKOEErUtgGT9q6Dq/XIiXA0T6H1vn7mY8aoXOXxdqxFB6G
hlTq3HpgN2TabJKgZwth5GyB7tvrl/L48hecSwixWTnJuzcv5xWafaQStHnmj5n8
ifFE52YSwA6kVMtbXdEF/JOofZKARzKUK8fsfLqNaeyFTV8u3DfWiq3uNGVoaPi5
fOO26vOxqPgROv/qmSaRrWodR74fLJyU5qNKjqK6+kmdY3uNUq69/FUcRlJ/YSuR
z9V5M8RjlRDmN8tZOvbttZ98EY6rxNSvHZpEfQTpsTIn4t9fcNU=
=mu2R
-----END PGP SIGNATURE-----

--SnjIlKm7PS9z2fBUscfznnE0sCGWcQo2C--
