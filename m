From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Fwd: [PATCH 1/7] cifs: Bypass windows extended security for ntlmv2
 negotiate
Date: Fri, 22 Aug 2014 09:12:43 +0200
Message-ID: <53F6ED6B.3010108@samba.org>
References: <003401cfbc62$f505f920$df11eb60$@samsung.com> <CAH2r5muT0jBfh_K230dtNW5ZkVFx+evHiDA=+yoeG_PvDkCxmA@mail.gmail.com> <1408674742.9485.78.camel@ruth.wgtn.cat-it.co.nz> <1408681047.11134.15.camel@pico.ipa.ssimo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4b6W2WpveKPo3FKpgLi43d6xxJDWRKFkU"
Cc: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408681047.11134.15.camel-fj0lwfvWodpMy5p6ylGyhR2eb7JE58TQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4b6W2WpveKPo3FKpgLi43d6xxJDWRKFkU
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 22.08.2014 um 06:17 schrieb Simo:
> On Fri, 2014-08-22 at 14:32 +1200, Andrew Bartlett wrote:
>> On Wed, 2014-08-20 at 23:51 -0500, Steve French wrote:
>>> This is an unusual sounding issue.  Any comments on this from the aut=
h experts?
>>>
>>> Seems better to investigate this more if we end up enforcing a "must
>>> be within 5 minutes" threshold instead of this patch.  Have we done a=

>>> dochelp on this before?
>>
>> I am certainly nervous about this patch, as I've not ever seen this
>> before.  The thing that makes me feel particularly odd about this is
>> that:  In general, NTLMSSP clients don't have the server's time,
>=20
> This is simply false.
> Modern servers send the server timestamp in the TargetInfo Av_Pair
> structure in the challenge message [see MS-NLMP 2.2.2.1].
>=20
> In [MS-NLMP 3.1.5.1.2] it is explicitly mentioned that the client must
> use the provided (from the server) timestamp if present or current time=

> if it is not.

I talks about the MsvAvTimestamp from CHALLENGE_MESSAGE.TargetInfo.Value
not the timestamp from smb negprot.

I think it would make sense to skip the timestamp if the client doesn't
find the server time in CHALLENGE_MESSAGE.TargetInfo.Value
and notices that the local time isn't correct. E.g. the date is
before the year 2000.

metze


--4b6W2WpveKPo3FKpgLi43d6xxJDWRKFkU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlP27W4ACgkQm70gjA5TCD/t0ACgicKVxFMVW0gvUjIaNE6PxHVQ
nE8An3L2G7/3PLuBcr6+TPTis88d/lQW
=h3M1
-----END PGP SIGNATURE-----

--4b6W2WpveKPo3FKpgLi43d6xxJDWRKFkU--
